import Combine
import Foundation

@available(iOS 13.0, *)
public final class XYZBadgeManager {
    private let rootNode: XYZBadgeNode
    private let accessQueue = DispatchQueue(label: "com.xyzbadgemanager.accessQueue", qos: .utility)
    private var publishers = [XYZBadgePath: PassthroughSubject<Int, Never>]()
    
    private let persistenceURL: URL?
    private var saveWorkItem: DispatchWorkItem?

    public init(persistenceURL: URL? = nil) {
        self.persistenceURL = persistenceURL
        
        if let url = persistenceURL, let loadedRoot = Self.loadTreeFromDisk(url: url) {
            rootNode = loadedRoot
        } else {
            rootNode = XYZBadgeNode(name: "internal_root")
        }
        
        // 关键修正：只在根节点上设置一次回调。这是所有变化的唯一入口点。
        rootNode.onValueDidChange = { [weak self] originatingNode in
            self?.handleTreeValueChange(from: originatingNode)
        }
    }

    // MARK: - Public API

    public func publisher(for path: XYZBadgePath) -> AnyPublisher<Int, Never> {
        accessQueue.sync {
            let node = findOrCreateNode(for: path)
            let realPath = XYZBadgePath(key: node.path)
            if publishers[realPath] == nil {
                publishers[realPath] = PassthroughSubject<Int, Never>()
            }
            return publishers[realPath]!
                .prepend(_getTotalValue_unsafe(for: path)) // 立即返回一次回调, 这个path参数要用不含root的
                .eraseToAnyPublisher()
        }
    }

    public func update(path: XYZBadgePath, value: Int) {
        accessQueue.async {
            self.findOrCreateNode(for: path).value = value
        }
    }
    
    public func increment(path: XYZBadgePath, by amount: Int = 1) {
        accessQueue.async {
            self.findOrCreateNode(for: path).value += amount
        }
    }
    
    public func decrement(path: XYZBadgePath, by amount: Int = 1) {
        accessQueue.async {
            let node = self.findOrCreateNode(for: path)
            node.value = max(0, node.value - amount)
        }
    }
    
    public func reset(path: XYZBadgePath) {
        update(path: path, value: 0)
    }
    
    public func getTotalValue(for path: XYZBadgePath) -> Int {
        accessQueue.sync {
            _getTotalValue_unsafe(for: path)
        }
    }

    //  Private Core Logic
    
    private func _getTotalValue_unsafe(for path: XYZBadgePath) -> Int {
        return findOrCreateNode(for: path).totalValue
    }

    private func handleTreeValueChange(from originatingNode: XYZBadgeNode) {
        var currentNode: XYZBadgeNode? = originatingNode
        while let node = currentNode {
            let path = XYZBadgePath(key: node.path)
            if !path.rawValue.isEmpty, let subject = publishers[path] {
                subject.send(node.totalValue)
            }
            currentNode = node.parentNode
        }
        
        if persistenceURL != nil {
            scheduleSave()
        }
    }
    
    private func findOrCreateNode(for path: XYZBadgePath) -> XYZBadgeNode {
        let components = path.components
        var currentNode = rootNode
        for component in components {
            currentNode = currentNode.addChild(name: component)
        }
        return currentNode
    }
}

// MARK: 持久化

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
private extension XYZBadgeManager {
    func scheduleSave() {
        saveWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in self?.saveTreeToDisk() }
        accessQueue.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        saveWorkItem = workItem
    }
    
    func saveTreeToDisk() {
        guard let url = persistenceURL else { return }
        do {
            let data = try JSONEncoder().encode(rootNode)
            try data.write(to: url, options: .atomic)
        } catch {
            print("XYZBadgeManager: Failed to save tree to disk. Error: \(error)")
        }
    }

    static func loadTreeFromDisk(url: URL) -> XYZBadgeNode? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(XYZBadgeNode.self, from: data)
    }
}

/// 红点树的节点类
private final class XYZBadgeNode: Codable, CustomDebugStringConvertible {
    var name: String
    var value: Int = 0 {
        didSet {
            if oldValue != value {
                // 从当前节点开始，向上冒泡变化通知
                propagateChange(from: self)
            }
        }
    }
    
    private(set) var childNodes: [String: XYZBadgeNode] = [:]
    private(set) weak var parentNode: XYZBadgeNode?
    
    /// 当此节点或其任何子孙节点的值发生变化时触发的回调。
    /// 这个闭包只应该在根节点上被设置。
    var onValueDidChange: ((_ originatingNode: XYZBadgeNode) -> Void)?

    /// 一个只读的计算属性，永远返回正确的值。
    var totalValue: Int {
        return value + childNodes.values.reduce(0) { $0 + $1.totalValue }
    }
    
    var path: String {
        if let parent = parentNode {
            return parent.path + "." + name
        }
        return name
    }

    init(name: String, parent: XYZBadgeNode? = nil) {
        self.name = name
        parentNode = parent
    }
    
    @discardableResult
    func addChild(name: String) -> XYZBadgeNode {
        if let existingChild = childNodes[name] {
            return existingChild
        } else {
            let newChild = XYZBadgeNode(name: name, parent: self)
            childNodes[name] = newChild
            // 当结构变化时，也需要通知，以便父节点重新计算totalValue
            propagateChange(from: self)
            return newChild
        }
    }

    /// 递归地将变化通知向上传递到根节点。
    private func propagateChange(from originatingNode: XYZBadgeNode) {
        // 尝试执行当前节点的回调。对于非根节点，这将什么都不做。
        // 当冒泡到根节点时，将触发Manager的逻辑。
        onValueDidChange?(originatingNode)
        
        // 让父节点继续传播
        parentNode?.propagateChange(from: originatingNode)
    }
    
    var debugDescription: String {
        return path
    }
    
    // MARK: - Codable & Child Management

    enum CodingKeys: String, CodingKey { case name, value, childNodes }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(Int.self, forKey: .value)
        childNodes = try container.decode([String: XYZBadgeNode].self, forKey: .childNodes)
        childNodes.values.forEach { $0.parentNode = self }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        try container.encode(childNodes, forKey: .childNodes)
    }
}

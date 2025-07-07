import Foundation

/// 一个类型安全的结构体，用于表示红点节点的路径，以消除直接使用字符串带来的风险。
public struct XYZBadgePath: Hashable {
    /// 路径的原始字符串值，例如 "tabBar.messages.private"
    public let rawValue: String

    /// 使用原始字符串初始化路径。
    /// - Parameter key: 路径字符串。
    public init(key: String) {
        // 简单验证路径是否合法
        precondition(!key.contains(" "), "XYZBadgePath cannot contain spaces")
        precondition(!(key.hasSuffix(".") || key.hasPrefix(".")), "XYZBadgePath cannot start or end with a dot")
        precondition(!key.isEmpty, "key cannot be empty")

        self.rawValue = key
    }

    /// 在当前路径下追加一个新的路径组件。
    /// - Parameter component: 要追加的路径组件字符串。
    /// - Returns: 一个新的、更长的路径。
    public func appending(_ component: String) -> XYZBadgePath {
        precondition(!component.contains(" "), "component 不能包含空格")
        precondition(!(component.hasSuffix(".") || component.hasPrefix(".")), "component 不能以.开头或结尾")

        guard !rawValue.isEmpty else {
            return XYZBadgePath(key: component)
        }
        guard !component.isEmpty else {
            return self
        }
        return XYZBadgePath(key: "\(rawValue).\(component)")
    }

    /// 获取路径的各个组件
    public var components: [String] {
        rawValue.components(separatedBy: ".")
    }
}
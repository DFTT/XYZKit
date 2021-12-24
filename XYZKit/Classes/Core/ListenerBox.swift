//
//  File.swift
//  XYZKit
//
//  Created by 大大东 on 2021/11/12.
//

/// 一个包装器, 便于为一个属性增加一个listener
/// 例如:
///  struct Person {
///     var name: String
///  }
///  如果需要在监停name的变化, 则可以修改属性的声明
///  struct Person {
///     var name: ListenerBox<String>
///  }
///  这样就可以在其它位置对此属性的变化 添加listener监听

public struct ListenerBox<T> {
    public typealias ValueChangeBlock = (T) -> Void
    public var value: T {
        didSet {
            listenerBlocks?.forEach { block in
                block(value)
            }
        }
    }

    init(_ value: T) {
        self.value = value
    }

    public mutating func addLister(_ block: @escaping ValueChangeBlock) {
        if listenerBlocks == nil {
            listenerBlocks = [ValueChangeBlock]()
        }
        listenerBlocks!.append(block)
    }

    private var listenerBlocks: [ValueChangeBlock]?
}

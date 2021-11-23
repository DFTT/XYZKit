//
//  File.swift
//  XYZKit
//
//  Created by 大大东 on 2021/11/12.
//

struct ListenerBox<T> {
    typealias ValueChangeBlock = (T) -> Void
    var value: T {
        didSet {
            listenerBlocks?.forEach { block in
                block(value)
            }
        }
    }

    private var listenerBlocks: [ValueChangeBlock]?
    mutating func addLister(_ block: @escaping ValueChangeBlock) {
        if listenerBlocks == nil {
            listenerBlocks = [ValueChangeBlock]()
        }
        listenerBlocks!.append(block)
    }
}

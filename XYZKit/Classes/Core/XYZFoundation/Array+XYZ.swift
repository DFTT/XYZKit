//
//  Array+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2021/12/1.
//

import Foundation

public extension Array {
    /// 不会越界的数组取值
    func safeObject(at index: Int) -> Self.Element? {
        guard (self.startIndex ..< self.endIndex).contains(index) else { return nil }
        return self[index]
    }

    /// 数组去重(保持原数组顺序)
    /// - Returns: 去重后的数组
    func filterDuplicate<E: Hashable>(_ filter: (Element) -> E) -> [Element] {
        if self.isEmpty {
            return self
        }
        var sets = Set<E>(minimumCapacity: self.count)
        return self.filter { sets.insert(filter($0)).inserted }
    }

    /// 追加不重复的元素(保持顺序追加)
    mutating func append<E: Hashable>(of array: [Element]?, filter: (Element) -> E) {
        guard let array = array, !array.isEmpty else {
            return
        }
        var sets = Set<E>(minimumCapacity: self.count + array.count)
        sets.formUnion(self.map { filter($0) })
        self.append(contentsOf: array.filter { sets.insert(filter($0)).inserted })
    }

    /// 转换为JSONString
    /// - Returns: json string
    var toJSONString: String? {
        guard JSONSerialization.isValidJSONObject(self),
              let jsonData = try? JSONSerialization.data(withJSONObject: self)
        else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }
}

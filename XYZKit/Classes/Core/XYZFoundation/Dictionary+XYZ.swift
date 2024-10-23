//
//  Dictionary+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/2/22.
//

import Foundation

public extension Dictionary {
    /// 是否包含key
    func contains(key: Key) -> Bool {
        return index(forKey: key) != nil
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

    /// 以json的格式打印在控制台 更便于阅读
    func prettyPrint() {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted), let jsonStr = String(data: data, encoding: .utf8) {
            print(jsonStr)
        } else {
            print(self)
        }
    }
}

// TODO: 这里有点纠结 使用这套方法 还是Optionel+XYZ.swift
// public extension Dictionary {
//    func string(forKey key: Key) -> String? {
//        switch self[key] {
//        case .none:
//            return nil
//        case .some(let wrapped):
//            if let v = wrapped as? String {
//                return v
//            }
//            if let v = wrapped as? Data {
//                return String(data: v, encoding: .utf8)
//            }
//            return "\(wrapped)"
//        }
//    }
//
//    func int(forKey key: Key) -> Int? {
//        switch self[key] {
//        case .none:
//            return nil
//        case .some(let wrapped):
//            if let v = wrapped as? Int {
//                return v
//            }
//            if let v = wrapped as? NSNumber {
//                return v.intValue
//            }
//            if let stringValue = wrapped as? String, let intValue = Int(stringValue) {
//                return intValue
//            }
//            if let intValue = Int("\(wrapped)") {
//                return intValue
//            }
//            return nil
//        }
//    }
//
//    func bool(forKey key: Key) -> Bool? {
//        let value = self[key]
//        if let boolValue = value as? Bool {
//            return boolValue
//        }
//        if let numberValue = value as? NSNumber {
//            return numberValue.boolValue
//        }
//        if let ss = string(forKey: key) {
//            return ss.bool
//        }
//
//        return false
//    }
// }

//
//  Dictionary+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/2/22.
//

import Foundation

public extension Dictionary {
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

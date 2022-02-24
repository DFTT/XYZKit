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
    func toJSONString() -> String? {
        guard JSONSerialization.isValidJSONObject(self),
              let jsonData = try? JSONSerialization.data(withJSONObject: self)
        else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }
}

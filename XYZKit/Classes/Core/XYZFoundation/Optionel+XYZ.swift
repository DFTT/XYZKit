//
//  Optionel+XYZ.swift
//  XYZKit
//
//  Created by dadadongl on 2024/7/19.
//

import Foundation

extension Optional where Wrapped: Any {
    var toString: String? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            if let v = wrapped as? String {
                return v
            }
            return "\(wrapped)"
        }
    }

    var toInt: Int? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            if let v = wrapped as? Int {
                return v
            }
            if let v = wrapped as? NSNumber {
                return v.intValue
            }
            if let stringValue = wrapped as? String, let intValue = Int(stringValue) {
                return intValue
            }
            if let intValue = Int("\(wrapped)") {
                return intValue
            }
            return nil
        }
    }

    var toBool: Bool {
        if let ss = toString {
            return ss.bool
        }
        return false
    }
}

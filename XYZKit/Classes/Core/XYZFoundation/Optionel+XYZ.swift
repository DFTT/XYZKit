//
//  Optionel+XYZ.swift
//  XYZKit
//
//  Created by dadadongl on 2024/7/19.
//

import Foundation

public extension Optional where Wrapped: Any {
    var asString: String? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            if let v = wrapped as? String {
                return v
            }
            if let v = wrapped as? Data {
                return String(data: v, encoding: .utf8)
            }
            return "\(wrapped)"
        }
    }

    var asInt: Int? {
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

    var asBool: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            if let boolValue = wrapped as? Bool {
                return boolValue
            }
            if let numberValue = wrapped as? NSNumber {
                return numberValue.boolValue
            }
            if let ss = asString {
                return ss.bool
            }
            return false
        }
    }
}

//
//  String+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    /// 从.xcasserts中获取对应名字的图片
    var image: UIImage? {
        return UIImage(named: self)
    }

    /// 根据特定格式字符串生成Color (字符串(0xRRGGBB ,0XRRGGBB, #RRGGBB))
    var color: UIColor? {
        return UIColor(rgbString: self)
    }

    /// 尝试解析为bool
    var bool: Bool {
        let ss = self.trimmed.lowercased()
        switch ss {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return !ss.isEmpty // 兜底, 不为空 即为true
        }
    }

    /// 转换为对应的json对象
    func toJSONObject() -> Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json
    }

    /// 清理串首尾的空格及换行
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// 检查字符串是否包含一个或多个数字
    ///   "abcd".hasNumbers -> false
    ///   "123abc".hasNumbers -> true
    var containsDigits: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }

    /// 检查字符串是否仅包含数字
    ///   "123".isDigits -> true
    ///   "1.3".isDigits -> false
    ///   "abc".isDigits -> false
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
}

// MARK: 编码

public extension String {
    /// base64编码
    var base64Encode: String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }

    /// base64解码
    var base64Decode: String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    /// URL编码 alamofire的方案
    var urlEncode: String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        let afURLQueryAllowed = CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)

        return self.addingPercentEncoding(withAllowedCharacters: afURLQueryAllowed) ?? ""
    }

    /// unicode编码
    var unicodeEncode: String {
        var tempStr = String()
        for v in self.utf16 {
            if v < 128 {
                tempStr.append(Unicode.Scalar(v)!.escaped(asASCII: true))
                continue
            }
            let codeStr = String(v, radix: 16, uppercase: false)
            tempStr.append("\\u" + codeStr)
        }

        return tempStr
    }

    /// unicode解码
    var unicodeDecode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

public extension String {
    /// KMP 查找字符串
    /// - Parameter p: 子字符串
    /// - Returns: 子字符串所在位置集合
    func kmpFindAll(_ p: String) -> [NSRange] {
        var ranges: [NSRange] = []
        let n = self.count
        let m = p.count
        let t = computePrefix(p)
        var q = 0
        for i in 0 ..< n {
            while q > 0, p.getCharacter(q) != self.getCharacter(i) {
                q = t[q]
            }
            if p.getCharacter(q) == self.getCharacter(i) {
                q += 1
            }
            if q == m {
                ranges.append(NSRange(location: i + 1 - m, length: m))
                q = t[q]
            }
        }
        return ranges
    }

    /// 计算KMP 对应前缀函数 数组
    /// - Parameter p:
    /// - Returns:
    fileprivate func computePrefix(_ p: String) -> [Int] {
        let m = p.count
        var t = Array(repeating: 0, count: m + 1)
        var k = 0
        for q in 1 ..< m {
            while k > 0, p.getCharacter(k) != p.getCharacter(q) {
                k = t[k]
            }
            if p.getCharacter(k) == p.getCharacter(q) {
                k += 1
            }
            t[q] = k
        }
        return t
    }

    /// 获取字符串中的字符
    /// - Parameter index: 字符位置
    /// - Returns: 字符
    fileprivate func getCharacter(_ index: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: index)
        return self[index]
    }
}

// MARK: - Path

public extension String {
    /// SwifterSwift: NSString lastPathComponent.
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// SwifterSwift: NSString pathExtension.
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// SwifterSwift: NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    /// SwifterSwift: NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// SwifterSwift: NSString pathComponents.
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// SwifterSwift: NSString appendingPathComponent(str: String).
    ///
    /// - Note: This method only works with file paths (not, for example, string representations of URLs.
    ///   See NSString [appendingPathComponent(_:)](https://developer.apple.com/documentation/foundation/nsstring/1417069-appendingpathcomponent)
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
}

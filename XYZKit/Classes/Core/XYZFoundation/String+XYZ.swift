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

    /// 转换为对应的json对象
    func toJSONObject() -> Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        return json
    }

    /// 清理串首尾的空格及换行
    var trimmingWhitespacesAndNewlines: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
    func kmpFindAll(_ p :String) -> [NSRange] {
        var ranges:[NSRange] = []
        let n = self.count
        let m = p.count
        let t = computePrefix(p)
        var q = 0
        for i in 0 ..< n {
            while q > 0 && !p.getCharacter(q).elementsEqual(self.getCharacter(i)) {
                q = t[q]
            }
            if p.getCharacter(q).elementsEqual(self.getCharacter(i)){
                q += 1
            }
            if q == m {
                ranges.append(NSRange.init(location: i + 1 - m, length: m))
                q = t[q]
            }
        }
        return ranges
    }
    
    /// 计算KMP 对应前缀函数 数组
    /// - Parameter p:
    /// - Returns:
    func computePrefix(_ p: String) -> [Int] {
        let m = p.count
        var t: [Int] = [Int](repeatElement(0, count: m + 1))
        t[0] = 0
        var k = 0
        for q in 1 ..< m {
            while k > 0 && !p.getCharacter(k).elementsEqual(p.getCharacter(q)){
                k = t[k]
            }
            if p.getCharacter(k).elementsEqual(p.getCharacter(q)) {
                k += 1
            }
            t[q] = k
        }
        return t
    }
    
    /// 获取字符串中的字符
    /// - Parameter index: 字符位置
    /// - Returns: 字符
    func getCharacter(_ index: Int) -> String {
        return getChildsString(index, 1)
    }
    
    /// 获取子字符串
    /// - Parameters:
    ///   - start: 开始位置
    ///   - length: 结束位置
    /// - Returns: 子字符串
    func getChildsString(_ start: Int, _ length: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: length)
        return String(self[startIndex ..< endIndex])
    }
}

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

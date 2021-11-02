//
//  UIColor+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

public extension UIColor {
    convenience init(rgbHex: Int, alpha: Float) {
        let r = CGFloat((rgbHex & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgbHex & 0xFF00) >> 8) / 255
        let b = CGFloat(rgbHex & 0xFF) / 255
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }

    /// 根据字符串生成Color
    /// - Parameters:
    ///   - rgbString: 字符串(0xRRGGBB ,0XRRGGBB, #RRGGBB)
    ///   - alpha: 透明度
    convenience init?(rgbString: String, alpha: Float = 1) {
        let str = rgbString.uppercased()
        var hex: String?
        if str.hasPrefix("#") {
            hex = String(str.suffix(from: str.index(str.startIndex, offsetBy: 1)))
        } else if str.hasPrefix("0X") {
            hex = String(str.suffix(from: str.index(str.startIndex, offsetBy: 2)))
        }
        // rrggbb
        guard let hex = hex, hex.count == 6, let intHex = Int(hex) else {
            return nil
        }
        self.init(rgbHex: intHex, alpha: alpha)
    }
}

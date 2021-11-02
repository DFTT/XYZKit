//
//  Int+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

// MARK: To Color

public extension Int {
    var color: UIColor {
        return UIColor(rgbHex: self, alpha: 1)
    }
}

// MARK: To Font

public extension Int {
    var font: UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self))
    }

    var fontMedium: UIFont {
        return UIFont.systemFont(ofSize: CGFloat(self), weight: .medium)
    }

    var fontBold: UIFont {
        return UIFont.boldSystemFont(ofSize: CGFloat(self))
    }

    var fontItalic: UIFont {
        return UIFont.italicSystemFont(ofSize: CGFloat(self))
    }

    func font(withName name: String) -> UIFont? {
        return UIFont(name: name, size: CGFloat(self))
    }
}

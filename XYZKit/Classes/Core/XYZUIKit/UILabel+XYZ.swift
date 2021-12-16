//
//  UILabel+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit

// MARK: 属性设置, 便于链式调用

public extension UILabel {
    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }

    @discardableResult
    func numberOfLines(_ num: Int) -> Self {
        self.numberOfLines = num
        return self
    }

    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }
}

//
//  String+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

public extension String {
    /// 从.xcasserts中获取对应名字的图片
    var image: UIImage? {
        return UIImage(named: self)
    }
}

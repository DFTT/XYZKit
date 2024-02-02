//
//  CGFloat+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2024/2/1.
//

import Foundation

public extension CGFloat {
    // 向上取整
    var ceil: CGFloat {
        return CGFloat(ceilf(Float(self)))
    }

    // 向下取整
    var floor: CGFloat {
        return CGFloat(floorf(Float(self)))
    }

    // 四舍五入
    var round: CGFloat {
        return CGFloat(roundf(Float(self)))
    }
}

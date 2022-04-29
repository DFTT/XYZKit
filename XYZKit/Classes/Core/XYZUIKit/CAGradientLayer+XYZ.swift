//
//  CAGradientLayer+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/4/28.
//

import Foundation

public extension CAGradientLayer {
    enum XYZGradientDirection {
        /// 水平从左到右
        case horizontal
        /// 直从上到下
        case vertical
        /// 左上到右下
        case leftTopToRightBottom
        /// 右上到左下
        case rightTopToLeftBottom
        /// 其他情况.
        case other(CGPoint, CGPoint)

        public func point() -> (CGPoint, CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0))
            case .vertical:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1))
            case .leftTopToRightBottom:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
            case .rightTopToLeftBottom:
                return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
            case .other(let stat, let end):
                return (stat, end)
            }
        }
    }

    func gradient(_ direction: XYZGradientDirection = .horizontal, _ gradientColors: [Any], _ gradientLocations: [NSNumber]? = nil) -> Self {
        // 设置渐变的颜色数组
        self.colors = gradientColors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        self.locations = gradientLocations
        // 设置渲染的起始结束位置（渐变方向设置）
        self.startPoint = direction.point().0
        self.endPoint = direction.point().1

        return self
    }
}

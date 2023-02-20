//
//  CAGradientLayer+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/4/28.
//

import Foundation

public extension CAGradientLayer {
    /// 线性渐变
    func gradient(_ direction: XYZGradientView.XYZGradientDirection = .horizontal, colors: [CGColor], locations: [NSNumber]? = nil) {
        self.type = .axial
        self.colors = colors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        self.locations = locations
        // 设置渲染的起始结束位置（渐变方向设置）
        self.startPoint = direction.points().0
        self.endPoint = direction.points().1
    }

    /// 环形渐变
    func radialGradient(_ direction: XYZGradientView.XYZGradientDirection = .linear(start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 1, y: 1)),
                        colors: [CGColor],
                        locations: [NSNumber]? = nil)
    {
        self.type = .radial
        self.colors = colors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        self.locations = locations
        // 设置渲染的起始结束位置（渐变方向设置）
        self.startPoint = direction.points().0
        self.endPoint = direction.points().1
    }

    /// 圆锥渐变
    @available(iOS 12, *)
    func conicGradient(_ direction: XYZGradientView.XYZGradientDirection = .linear(start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 0.5, y: 1)),
                       colors: [CGColor],
                       locations: [NSNumber]? = nil)
    {
        self.type = .conic
        self.colors = colors
        // 设置渐变颜色的终止位置，这些值必须是递增的，数组的长度和 colors 的长度最好一致
        self.locations = locations
        // 设置渲染的起始结束位置（渐变方向设置）
        self.startPoint = direction.points().0
        self.endPoint = direction.points().1
    }
}

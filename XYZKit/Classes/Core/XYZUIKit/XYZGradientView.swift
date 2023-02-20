//
//  XYZGradientView.swift
//  XYZKit
//
//  Created by 大大东 on 2022/10/28.
//

import Foundation

public class XYZGradientView: UIView {
    public enum XYZGradientDirection {
        /// 水平从左到右
        case horizontal
        /// 直从上到下
        case vertical
        /// 左上到右下
        case leftTopToRightBottom
        /// 右上到左下
        case rightTopToLeftBottom
        /// 自定义线性方向.
        /// 横/纵范围[0, 1]
        case linear(start: CGPoint, end: CGPoint)

        public func points() -> (start: CGPoint, end: CGPoint) {
            switch self {
            case .horizontal:
                return (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1))
            case .leftTopToRightBottom:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
            case .rightTopToLeftBottom:
                return (CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1))
            case .linear(let start, let end):
                return (start, end)
            }
        }
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public var type: CAGradientLayerType = .axial {
        didSet {
            self.syncConfig()
        }
    }

    /// 渐变方向
    public var direction: XYZGradientDirection = .horizontal {
        didSet {
            self.syncConfig()
        }
    }

    /// 径向渐变 仅双色
    /// 线性渐变 可多色
    public var colors: [UIColor] = [] {
        didSet {
            self.syncConfig()
        }
    }

    /// 渐变颜色分布位置 (例如: [0, 0.5, 1])
    public var locations: [Float]? {
        didSet {
            self.syncConfig()
        }
    }

    override public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow != nil {
            syncConfig()
        }
    }

    private func syncConfig() {
        let layer = (self.layer as! CAGradientLayer)
        layer.type = type
        layer.locations = locations?.map { NSNumber(value: $0 as Float) }
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = direction.points().0
        layer.endPoint = direction.points().1
    }
}

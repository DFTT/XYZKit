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
        /// 其他线性方向.
        /// 横/纵范围[0, 1]
        case linear(start: CGPoint, end: CGPoint)
        /// 径向渐变 (仅可用于 XYZGradientView)
        ///  start / end : 范围[0, 1]
        ///  startRadius / endRadius : 单位是pt
        case radial(start: CGPoint, startRadius: CGFloat, end: CGPoint, endRadius: CGFloat)

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
            case .radial(let start, _, let end, _):
                return (start, end)
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        // 支持绘制透明色 否则透明色会变成黑色
        backgroundColor = .white.withAlphaComponent(0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 渐变方向
    public var direction: XYZGradientDirection = .horizontal {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 径向渐变 仅双色
    /// 线性渐变 可多色
    public var colors: [UIColor] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    /// 渐变颜色分布位置 (例如: [0, 0.5, 1])
    public var locations: [Float]? {
        didSet {
            setNeedsDisplay()
        }
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        guard colors.isEmpty == false, let ctx = UIGraphicsGetCurrentContext() else { return }

        let colorArr = colors.map { $0.cgColor } as CFArray
        let locationArr = locations?.map { CGFloat($0) }
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colorArr, locations: locationArr)

        if gradient != nil {
            if case .radial(let start, let startRadius, let end, let endRadius) = direction {
                ctx.drawRadialGradient(gradient!,
                                       startCenter: __CGPointApplyAffineTransform(start, CGAffineTransform(scaleX: rect.size.width, y: rect.size.height)),
                                       startRadius: startRadius,
                                       endCenter: __CGPointApplyAffineTransform(end, CGAffineTransform(scaleX: rect.size.width, y: rect.size.height)),
                                       endRadius: endRadius,
                                       options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])

            } else {
                ctx.drawLinearGradient(gradient!,
                                       start: __CGPointApplyAffineTransform(direction.points().start, CGAffineTransform(scaleX: rect.size.width, y: rect.size.height)),
                                       end: __CGPointApplyAffineTransform(direction.points().end, CGAffineTransform(scaleX: rect.size.width, y: rect.size.height)),
                                       options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
            }
        }
    }
}

//
//  GuiderView.swift
//  GuideView
//
//  Created by wangwenjian on 2022/5/9.
//

import UIKit

/// 引导图
public class XYZGuideView: UIView {
    private let inView: UIView // 引导图显示在其上
    
    private var targetViews: [UIView] = [] // 需要镂空的视图
    
    private var hollowRects: [CGRect] = [] // 镂空的位置
    
    private lazy var annotations: [UIView] = [] // 添加的标注
    
    public var tapHide: Bool = false // 点击背景释放
    
    private var bezierPath: UIBezierPath?
    
    public convenience init(in view: UIView) {
        self.init(inView: view)
    }
    
    /// 蒙版位置
    /// - Parameter inView:
    init(inView: UIView) {
        self.inView = inView
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        inView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            self.leftAnchor.constraint(equalTo: self.inView.leftAnchor),
            self.topAnchor.constraint(equalTo: self.inView.topAnchor),
            self.rightAnchor.constraint(equalTo: self.inView.rightAnchor),
            self.bottomAnchor.constraint(equalTo: self.inView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        inView.layoutIfNeeded()
        bezierPath = UIBezierPath(rect: self.bounds)
        self.addTapGesture { [weak self] in
            if self?.tapHide == true {
                self?.dissmiss()
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func markMask() {
        let shape = CAShapeLayer()
        shape.path = bezierPath?.cgPath
        self.layer.mask = shape
    }
    
    /// 显示目标区域镂空
    /// - Parameters:
    ///   - view: 镂空位置的视图
    ///   - edge: 镂空边缘
    ///   - cornerRadius: 为镂空区域添加圆角
    public func show(target view: UIView, edge: UIEdgeInsets = .zero, cornerRadius: CGFloat = 0) {
        guard let path = bezierPath else {
            return
        }
        targetViews.append(view)
        let inRect = inView.convert(view.frame, to: inView)
        self.hollowRects.append(inRect)
        let rect = inRect.inset(by: edge)
        path.append(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).reversing())
        markMask()
    }
    
    /// 快捷添加图片标注
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - offset:
    ///   - targetView:
    public func addAnnotation(_ imageName: String, offset: CGPoint, targetView: UIView? = nil) {
        guard let image = UIImage(named: imageName) else {
            return
        }
        addAnnotation(UIImageView(image: image), offset: offset, targetView: targetView)
    }
        
    /// 添加标注
    /// - Parameters:
    ///   - view: 标柱内容
    ///   - offset: 标注相对于目标原点(x, y)偏移量
    ///   - targetView: 目标视图, 默认最近添加镂空的视图
    public func addAnnotation(_ view: UIView, offset: CGPoint, targetView: UIView? = nil) {
        var tView: UIView?
        if targetView != nil {
            tView = targetView
        } else {
            tView = targetViews.last
        }
        guard let tView = tView else {
            return
        }
        annotations.append(view)
        let origin = inView.convert(tView.frame, to: inView).origin
        inView.insertSubview(view, aboveSubview: self)
        let size = view.intrinsicContentSize
        view.frame = CGRect(x: origin.x + offset.x, y: origin.y + offset.y, width: size.width, height: size.height)
    }
        
    // 释放当前显示的引导
    public func clearCurrentSubs() {
        annotations.forEach { view in
            view.removeFromSuperview()
        }
        annotations.removeAll()
        bezierPath = UIBezierPath(rect: self.bounds)
        markMask()
    }
    
    /// 隐藏引导
    public func dissmiss() {
        clearCurrentSubs()
        self.removeFromSuperview()
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for inRect in hollowRects {
            if inRect.contains(point) {
                return nil
            } else {
                return self
            }
        }
        return self
    }
}

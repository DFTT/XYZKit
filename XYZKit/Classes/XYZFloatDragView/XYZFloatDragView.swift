//
//  XYZFloatView.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/16.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

open class XYZFloatDragView: UIView {
    public enum DockDirection: Int {
        case horizontal
        case left
        case right
    }

    public var dock: DockDirection {
        didSet {
            self.autoDock = dock
            self.setAutoDockIfNeed()
        }
    }

    public var enable: Bool = true {
        didSet {
            self.enableDrag = enable
            if self.window != nil {
                self.setAutoDockIfNeed()
            }
        }
    }

    /// 拖动松手后 自动吸边的动画中block 可以同步进行一些动画
    public var dockingAnimationBlcck: ((CGPoint) -> Void)?

    /// 自动吸边的动画完成后的回调
    public var dockEndBlcck: (() -> Void)?

    override public init(frame: CGRect) {
        dock = .horizontal
        super.init(frame: frame)
        self.enableDrag = true
        self.autoDock = dock
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if self.window != nil {
            self.setAutoDockIfNeed()
        }
    }
}

private extension UIView {
    /// 是否可以拖动
    var enableDrag: Bool {
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.enabledrag, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                // 需要拖动 强制开启
                self.isUserInteractionEnabled = true
            }

            var panGes = self.float_panGesture
            if panGes == nil {
                panGes = UIPanGestureRecognizer(target: self, action: #selector(float_pangesAction(_:)))
                self.addGestureRecognizer(panGes!)
                self.float_panGesture = panGes
            }
            panGes!.isEnabled = newValue
        }
        get {
            return (objc_getAssociatedObject(self, &_AssociatedKeys.enabledrag) as? Bool) ?? false
        }
    }

    /// 松手后是否自动吸边(左右)
    var autoDock: XYZFloatDragView.DockDirection {
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.autodock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, &_AssociatedKeys.autodock) as? XYZFloatDragView.DockDirection) ?? .horizontal
        }
    }

//    /// 拖动松手后 自动吸边的动画中block 可以同步进行一些动画
//    var dockingAnimationBlcck: ((CGPoint) -> Void)?
//
//    /// 自动吸边的动画完成后的回调
//    var dockEndBlcck: (() -> Void)?

    /// 立即停靠
    func setAutoDockIfNeed() {
        let view = self
        guard let superview = view.superview else {
            return
        }

        let viaiableRect: CGRect
        if #available(iOS 11, *) {
            viaiableRect = superview.bounds.inset(by: superview.safeAreaInsets)
        } else {
            viaiableRect = superview.bounds
        }

        let viewSize = view.bounds.size
        // center有效区域
        let centerVisiableRect = viaiableRect.inset(by: UIEdgeInsets(top: viewSize.height / 2, left: viewSize.width / 2, bottom: viewSize.height / 2, right: viewSize.width / 2))
        //
        var newCenter = view.center
        if self.autoDock == .horizontal {
            if newCenter.x > centerVisiableRect.maxX / 2 {
                newCenter.x = centerVisiableRect.maxX
            } else {
                newCenter.x = centerVisiableRect.minX
            }
        } else if self.autoDock == .left {
            newCenter.x = centerVisiableRect.minX
        } else if self.autoDock == .right {
            newCenter.x = centerVisiableRect.maxX
        }

        if newCenter == view.center {
            if let vv = view as? XYZFloatDragView {
                vv.dockingAnimationBlcck?(newCenter)
                vv.dockEndBlcck?()
            }
            return
        }

        let vv = view as? XYZFloatDragView

        // 更新
        UIView.animate(withDuration: 0.25) {
            view.center = newCenter
            vv?.dockingAnimationBlcck?(newCenter)
        } completion: { _ in
            vv?.dockEndBlcck?()
        }
    }

    private enum _AssociatedKeys {
        static var pangesture = "_pangesture"
        static var enabledrag = "_enableDrag"
        static var autodock = "_autodock"
    }

    private var float_panGesture: UIPanGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, &_AssociatedKeys.pangesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &_AssociatedKeys.pangesture) as? UIPanGestureRecognizer
        }
    }

    @objc private func float_pangesAction(_ panges: UIPanGestureRecognizer) {
        let view = self
        guard let superview = view.superview else {
            return
        }

        switch panges.state {
        case .began, .changed:

            let viaiableRect: CGRect
            if #available(iOS 11, *) {
                viaiableRect = superview.bounds.inset(by: superview.safeAreaInsets)
            } else {
                viaiableRect = superview.bounds
            }

            let viewSize = view.bounds.size
            // center有效区域
            let centerVisiableRect = viaiableRect.inset(by: UIEdgeInsets(top: viewSize.height / 2, left: viewSize.width / 2, bottom: viewSize.height / 2, right: viewSize.width / 2))
            // 偏移
            let transPoint = panges.translation(in: panges.view)
            // 确保不超出有效区域
            var newCenter = CGPoint(x: view.center.x + transPoint.x, y: view.center.y + transPoint.y)
            newCenter.x = min(max(newCenter.x, centerVisiableRect.minX), centerVisiableRect.maxX)
            newCenter.y = min(max(newCenter.y, centerVisiableRect.minY), centerVisiableRect.maxY)
            // 更新
            view.center = newCenter
        case .failed, .ended, .cancelled:
            setAutoDockIfNeed()
        default:
            break
        }

        panges.setTranslation(CGPoint.zero, in: superview)
    }
}

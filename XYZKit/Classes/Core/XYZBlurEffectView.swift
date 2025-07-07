//
//  XYZBlurEffectView.swift
//  XYZKit
//
//  Created by 大大东 on 2024/2/2.
//

import Foundation

// 可以调整模糊程度的视图

@available(iOS 11.0, *)
public class XYZBlurEffectView: UIView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        effectView?.frame = bounds
    }

    deinit {
        animator?.stopAnimation(true)
    }

    /// 配置模糊参数
    /// - Parameters:
    ///   - style: 模糊类型
    ///   - level: 模糊程度 [0, 1]
    public func config(style: UIBlurEffect.Style, level: Float) {
        if animator != nil {
            animator?.stopAnimation(true)
        }
        if effectView != nil {
            effectView?.removeFromSuperview()
            effectView = nil
        }

        effectView = UIVisualEffectView(frame: bounds)
        addSubview(effectView!)

        animator = UIViewPropertyAnimator(duration: 0, curve: .linear) { [weak self] in
            self?.effectView?.effect = UIBlurEffect(style: style)
        }

        var level = level
        if level > 1 {
            level = 1
        } else if level < 0 {
            level = 0
        }
        animator!.fractionComplete = CGFloat(level)
        animator!.pausesOnCompletion = true
    }

    private var effectView: UIVisualEffectView?

    private var animator: UIViewPropertyAnimator?
}

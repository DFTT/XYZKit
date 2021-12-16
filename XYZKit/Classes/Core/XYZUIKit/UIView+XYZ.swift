//
//  UIView+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

// MARK: 属性设置, 便于链式调用

public extension UIView {
    @discardableResult
    func bgColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    func clipsCornerRadius(_ radius: Float) -> Self {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        return self
    }
}

// MARK: TapGesture

public extension UIView {
    func addTapGesture(_ action: @escaping () -> Void) {
        let tap = UITapGestureRecognizer(actionBlock: action)
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
}

// MARK: Snap

public extension UIView {
    /// 生成当前View截图
    /// - Parameter screenScale: 控制图片分辨率(1~3)
    /// - Returns: UIImage
    func snapShotImage(screenScale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, screenScale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: Animation

public extension UIView {
    func fadeShowIn(_ view: UIView) {
        view.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.24) {
            self.alpha = 1
        }
    }

    func fadeRemoveFromSuperview() {
        self.alpha = 1
        UIView.animate(withDuration: 0.24) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

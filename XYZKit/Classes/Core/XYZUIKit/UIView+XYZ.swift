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

    func shakeAnimation(_ duration: TimeInterval = 0.6) {
        self.layer.removeAllAnimations()

        let center = self.center
        let moveXLeft = center.x - 5
        let moveXRight = center.x + 5
        let shakeAni = QuartzCore.CAKeyframeAnimation(keyPath: "position.x")
        shakeAni.duration = duration
        shakeAni.values = [center.x,
                           moveXLeft, moveXRight,
                           moveXLeft, moveXRight,
                           moveXLeft, moveXRight,
                           moveXLeft, moveXRight,
                           center.x]
        DispatchQueue.main.async {
            self.layer.add(shakeAni, forKey: "__shake__")
        }
    }

    func bounceAnimation(_ duration: TimeInterval = 0.8) {
        self.layer.removeAllAnimations()

        let time_1 = QuartzCore.CAMediaTimingFunction(controlPoints: 0.215, 0.610, 0.355, 1)
        let time_2 = QuartzCore.CAMediaTimingFunction(controlPoints: 0.755, 0.050, 0.855, 0.060)

        let y = self.center.y
        let value_0 = y
        let value_1 = y - 15
        let value_2 = y - 8
        let value_3 = y - 2

        let bonceAni = QuartzCore.CAKeyframeAnimation(keyPath: "position.y")
        bonceAni.duration = duration
        bonceAni.values = [value_0, value_1, value_1, value_0, value_2, value_0, value_3]
        bonceAni.keyTimes = [0.2, 0.4, 0.43, 0.53, 0.7, 0.8, 0.9]
        bonceAni.timingFunctions = [time_1, time_2, time_2, time_1, time_2, time_1, time_1, time_2]
        DispatchQueue.main.async {
            self.layer.add(bonceAni, forKey: "__bonce__")
        }
    }

    func swingAnimtion(_ duration: TimeInterval = 0.8) {
        self.layer.removeAllAnimations()

        let rotateF = 15 * Double.pi / 180.0
        let rotateS = 10 * Double.pi / 180.0
        let rotateT = 5 * Double.pi / 180.0

        let swingAni = QuartzCore.CAKeyframeAnimation(keyPath: "transform")
        swingAni.duration = duration
        swingAni.values = [CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0),
                           CATransform3DRotate(CATransform3DIdentity, rotateF, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, -rotateS, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, rotateT, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, -rotateT, 0, 0, 1),
                           CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 1)]
        DispatchQueue.main.async {
            self.layer.add(swingAni, forKey: "__swing__")
        }
    }
}

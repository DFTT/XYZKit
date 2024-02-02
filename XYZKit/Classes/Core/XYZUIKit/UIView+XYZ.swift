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
    func frame(_ rect: CGRect) -> Self {
        self.frame = rect
        return self
    }

    @discardableResult
    func bgColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    @discardableResult
    func hidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    @discardableResult
    func tintColor(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }

    @discardableResult
    func clipsCornerRadius(_ radius: Float) -> Self {
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
        return self
    }
}

// MARK: Frame/Bounds

public extension UIView {
    /// 自己坐标系中心坐标
    var boundsCenter: CGPoint {
        return CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
    }

    /// 图层中所属的ViewController
    var viewController: UIViewController? {
        var nextResp = self.next
        while nextResp != nil {
            if nextResp!.isKind(of: UIViewController.self) {
                return (nextResp as! UIViewController)
            } else {
                nextResp = nextResp?.next
            }
        }
        return nil
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
    /// - Parameter screenScale: 控制图片分辨率(x1~x3), 大图时建议设置为1, 否则图片物理内存很大
    /// - Returns: UIImage
    func snapShotImage(screenScale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, screenScale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: 获取某一点颜色

public extension UIView {
    func colorWithPoint(_ point: CGPoint) -> UIColor? {
        guard self.bounds.contains(point) else {
            return nil
        }

        let colorspace = CGColorSpaceCreateDeviceRGB()
        var rgba: [UInt8] = [0, 0, 0, 0]
        guard let bitmapCtx = CGContext(data: &rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorspace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }
        bitmapCtx.translateBy(x: -point.x, y: -point.y)

        self.layer.render(in: bitmapCtx)

        let r = CGFloat(rgba[0]) / CGFloat(255)
        let g = CGFloat(rgba[1]) / CGFloat(255)
        let b = CGFloat(rgba[2]) / CGFloat(255)
        let a = CGFloat(rgba[3]) / CGFloat(255)
        return UIColor(red: r, green: g, blue: b, alpha: a)
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

    func shakeAnimation(_ duration: TimeInterval = 0.6, isRepeat: Bool = false) {
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
        shakeAni.repeatCount = isRepeat ? Float.greatestFiniteMagnitude : 1
        DispatchQueue.main.async {
            self.layer.add(shakeAni, forKey: "__shake__")
        }
    }

    func bounceAnimation(_ duration: TimeInterval = 0.8, isRepeat: Bool = false) {
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
        bonceAni.repeatCount = isRepeat ? Float.greatestFiniteMagnitude : 1
        DispatchQueue.main.async {
            self.layer.add(bonceAni, forKey: "__bonce__")
        }
    }

    func swingAnimtion(_ duration: TimeInterval = 0.8, isRepeat: Bool = false) {
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
        swingAni.repeatCount = isRepeat ? Float.greatestFiniteMagnitude : 1
        DispatchQueue.main.async {
            self.layer.add(swingAni, forKey: "__swing__")
        }
    }
}

// MARK: 扩大点击区域

public extension UIView {
    var expandInsets: UIEdgeInsets {
        get {
            let inset = (objc_getAssociatedObject(self, &XYZAssociatedKeys.viewExpandKey) as? UIEdgeInsets)
            return inset ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &XYZAssociatedKeys.viewExpandKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            _ = XYZ_UIView_Swizzling.pointInside_swizzling
        }
    }

    @objc private func xyz_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if expandInsets == .zero {
            return xyz_point(inside: point, with: event)
        } else {
            var res = xyz_point(inside: point, with: event)
            if !res {
                let newRect = CGRect(x: bounds.origin.x - expandInsets.left,
                                     y: bounds.origin.y - expandInsets.top,
                                     width: bounds.size.width + expandInsets.left + expandInsets.right,
                                     height: bounds.size.height + expandInsets.top + expandInsets.bottom)
                res = newRect.contains(point)
            }
            return res
        }
    }

    private struct XYZ_UIView_Swizzling {
        static let pointInside_swizzling = XYZ_UIView_Swizzling()
        init() {
            let classType = UIView.self
            let oriSelector = #selector(point(inside:with:))
            let swizzleSelector = #selector(xyz_point(inside:with:))
            guard let originMethed = class_getInstanceMethod(classType, oriSelector),
                  let swizzleMethed = class_getInstanceMethod(classType, swizzleSelector)
            else {
                return
            }

            let didAddMethod = class_addMethod(classType, oriSelector, method_getImplementation(swizzleMethed), method_getTypeEncoding(swizzleMethed))

            if didAddMethod {
                class_replaceMethod(classType, swizzleSelector, method_getImplementation(originMethed), method_getTypeEncoding(originMethed))
            } else {
                method_exchangeImplementations(originMethed, swizzleMethed)
            }
        }
    }
}

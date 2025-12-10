//
//  UIApplication+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2024/2/20.
//

import Foundation

public extension UIApplication {
    // 这个方法 做不到所有项目都通用
    static func window() -> UIWindow? {
        if !Thread.isMainThread {
            assertionFailure("window() should be called on main thread")
        }

        var wid: UIWindow?
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }

            let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first

            if let del = scene?.delegate as? UIWindowSceneDelegate {
                wid = del.window ?? nil
            }
            if wid == nil {
                wid = scene?.windows.first { $0.isKeyWindow }
            }
            if wid == nil {
                wid = scene?.windows.first
            }
        }

        if wid == nil, let del = UIApplication.shared.delegate {
            wid = del.window ?? nil
        }
        if wid == nil {
            wid = UIApplication.shared.keyWindow
        }
        if wid == nil {
            wid = UIApplication.shared.windows.first
        }

        return wid
    }

    static func topViewController(_ onWindow: UIWindow? = nil) -> UIViewController? {
        guard let root = (onWindow ?? window())?.rootViewController else { return nil }

        var topVc: UIViewController? = root
        var irCount = 0
        while irCount < 10 {
            irCount += 1
            if let vc = topVc?.presentedViewController,
               (vc as? UIAlertController) == nil
            {
                topVc = vc
            } else if let nav = topVc as? UINavigationController {
                topVc = nav.topViewController
            } else if let tab = topVc as? UITabBarController {
                topVc = tab.selectedViewController
            } else {
                break
            }
        }
        return topVc
    }
}

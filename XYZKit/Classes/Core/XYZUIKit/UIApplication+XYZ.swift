//
//  UIApplication+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2024/2/20.
//

import Foundation

public extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard let del = UIApplication.shared.delegate,
              let root = del.window??.rootViewController else { return nil }

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

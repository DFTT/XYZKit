//
//  UINavigationController+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2022/11/3.
//

import Foundation

public extension UINavigationController {
    /// push到一个新页面, 同时移除指定的vc
    /// - Parameters:
    ///   - viewController: 将要push的新页面
    ///   - remove: 将会从viewcontrillers中移除的 已存在的vc
    ///   - animated: 是否动画
    func pushViewController(_ viewController: UIViewController, remove: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs.removeAll { $0 === remove }
        vcs.append(viewController)
        setViewControllers(vcs, animated: animated)
    }
}

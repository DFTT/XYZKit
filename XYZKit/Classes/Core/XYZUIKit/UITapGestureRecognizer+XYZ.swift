//
//  UITapGestureRecognizer+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/22.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

// MARK: 便捷创建有Block点击事件的手势

public extension UITapGestureRecognizer {
    convenience init(actionBlock: @escaping () -> Void) {
        self.init()

        let val = Xyz_TapGesAction(actionBlock)
        objc_setAssociatedObject(self, &XYZAssociatedKeys.gestureActionBlockKey, val, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        addTarget(val, action: #selector(Xyz_TapGesAction.tapActionFunc))
    }

    private class Xyz_TapGesAction {
        var __action: () -> Void
        init(_ action: @escaping () -> Void) {
            __action = action
        }

        @objc func tapActionFunc() {
            __action()
        }
    }
}

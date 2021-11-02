//
//  UITapGestureRecognizer+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/22.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

public extension UITapGestureRecognizer {
    convenience init(actionBlock: @escaping () -> Void) {
        self.init()

        let val = Xyz_TapGesAction(actionBlock)
        objc_setAssociatedObject(self, &xyz_AssociatedKes.assActionkey, val, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

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

    private enum xyz_AssociatedKes {
        static var assActionkey = "_assActionkey"
    }
}

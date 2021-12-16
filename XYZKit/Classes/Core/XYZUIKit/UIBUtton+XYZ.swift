//
//  UIBUtton+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit

// MARK: 属性设置, 便于链式调用

public extension UIButton {
    @discardableResult
    func title(_ title: String?, for state: UIControl.State) -> Self {
        self.setTitle(title, for: state)
        return self
    }

    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.setImage(image, for: state)
        return self
    }

    @discardableResult
    func bgImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }
}

// MARK: 便捷为button 添加一个Block点击事件

public extension UIButton {
    func tapAction(_ action: @escaping (UIButton) -> Void) {
        if self.xyz_btnActionBlock != nil {
            return
        }
        self.xyz_btnActionBlock = action
        self.addTarget(self, action: #selector(xyz_btnActionFunc), for: .touchUpInside)
    }

    @objc private func xyz_btnActionFunc() {
        self.xyz_btnActionBlock?(self)
    }

    private enum xyz_associatedKeys {
        static var btnActionBlockKey = "xyz_btnActionBlockKey"
    }

    private var xyz_btnActionBlock: ((_ btn: UIButton) -> Void)? {
        set {
            objc_setAssociatedObject(self, &xyz_associatedKeys.btnActionBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &xyz_associatedKeys.btnActionBlockKey) as? ((UIButton) -> Void)
        }
    }
}

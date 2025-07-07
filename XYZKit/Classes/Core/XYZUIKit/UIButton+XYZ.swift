//
//  UIButton+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit

// MARK: 属性设置, 便于链式调用

public extension UIButton {
    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

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
        self.addTarget(self, action: #selector(self.xyz_btnActionFunc), for: .touchUpInside)
    }

    @objc private func xyz_btnActionFunc() {
        self.xyz_btnActionBlock?(self)
    }

    private var xyz_btnActionBlock: ((_ btn: UIButton) -> Void)? {
        set {
            objc_setAssociatedObject(self, &XYZAssociatedKeys.btnActionBlockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &XYZAssociatedKeys.btnActionBlockKey) as? ((UIButton) -> Void)
        }
    }
}

// MARK: BUtton image/title位置

public extension UIButton {
    /// 图片 和 title 的布局样式
    enum XYZButtonImgLayout {
        case imgTop
        case imgBottom
        case imgLeft
        case imgRight
    }

    /// 按钮图片/标题位置调整
    /// - Parameters:
    ///   - imageAlignment: 图文排列方式
    ///   - spacing: 图文间距
    func setImageTitleLayout(_ imageAlignment: XYZButtonImgLayout, spacing: CGFloat = 0) {
        guard let imageSize = self.imageView?.image?.size,
              let titleSize = self.titleLabel?.intrinsicContentSize
        else {
            return
        }

        switch imageAlignment {
        case .imgTop, .imgBottom:
            let imageVerticalOffset = (titleSize.height + spacing)/2
            let titleVerticalOffset = (imageSize.height + spacing)/2
            let imageHorizontalOffset = (titleSize.width)/2
            let titleHorizontalOffset = (imageSize.width)/2
            let sign: CGFloat = imageAlignment == .imgTop ? 1 : -1

            self.imageEdgeInsets = UIEdgeInsets(top: -imageVerticalOffset * sign,
                                                left: imageHorizontalOffset,
                                                bottom: imageVerticalOffset * sign,
                                                right: -imageHorizontalOffset)
            self.titleEdgeInsets = UIEdgeInsets(top: titleVerticalOffset * sign,
                                                left: -titleHorizontalOffset,
                                                bottom: -titleVerticalOffset * sign,
                                                right: titleHorizontalOffset)
        case .imgLeft:
            let edgeOffset = spacing/2
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: -edgeOffset,
                                                bottom: 0,
                                                right: edgeOffset)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: edgeOffset,
                                                bottom: 0,
                                                right: -edgeOffset)
        case .imgRight:
            let edgeOffset = spacing/2
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: titleSize.width + edgeOffset,
                                                bottom: 0,
                                                right: -titleSize.width - edgeOffset)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: -imageSize.width - edgeOffset,
                                                bottom: 0,
                                                right: imageSize.width + edgeOffset)
        }
    }
}

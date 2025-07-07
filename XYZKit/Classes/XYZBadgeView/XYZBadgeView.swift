//
//  XYZBadgeView.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2021/11/23.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

/*
  ____________________
 |     badgeView      |
 |    ------------    |
 |   | contentView|   |
 |   |  --------  |   |
 |   | | label  | |   |
 |   |  --------  |   |
 |    ------------    |
 |                    |
  --------------------
 UI样式如上, 提供了一个角标布局
 根据需可以调整 badgeView / contentView的padding
 根据需可以调整 contentView.label的 font/text/textcolor
 已经重写intrinsicContentSize, 支持自撑大
  */
public class XYZBadgeView: UIView {
    public var padding = UIEdgeInsets.zero {
        didSet {
            self.setNeedsLayout()
        }
    }

    public private(set) var contentView: BadgeContentView

    public convenience init(_ bgColor: UIColor) {
        self.init(bg: BadgeContentView(color: bgColor))
    }

    public convenience init(_ bgImage: UIImage, stretchAxis: BadgeContentView.BadgeBgImgStretchAxis) {
        self.init(bg: BadgeContentView(img: bgImage, stretchAxis: stretchAxis))
    }

    init(bg: BadgeContentView) {
        self.contentView = bg
        super.init(frame: .zero)
        addSubview(self.contentView)
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        let size = self.contentView.intrinsicContentSize
        return CGSize(width: size.width + self.padding.left + self.padding.right,
                      height: size.height + self.padding.top + self.padding.bottom)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(by: self.padding)
        self.contentView.layer.cornerRadius = self.contentView.bounds.height / 2
    }

    // MARK: BGView

    public class BadgeContentView: UIImageView {
        public enum BadgeBgImgStretchAxis {
            case unable, horizontal, horizontalAndVertical
        }

        public var padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) {
            didSet {
                self.superview?.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
            }
        }

        public var font = 11.font {
            didSet {
                self.textLabel.font = self.font
                self.superview?.invalidateIntrinsicContentSize()
            }
        }

        public var text = "" {
            didSet {
                self.textLabel.text = self.text
                self.superview?.invalidateIntrinsicContentSize()
            }
        }

        public var textColor = UIColor.white {
            didSet {
                self.textLabel.textColor = self.textColor
            }
        }

        private lazy var textLabel: UILabel = {
            let label = UILabel().font(self.font).textColor(self.textColor).textAlignment(.center)
            addSubview(label)
            return label
        }()

        private var allowStretchAxis = BadgeBgImgStretchAxis.horizontalAndVertical

        init(img: UIImage, stretchAxis: BadgeBgImgStretchAxis) {
            super.init(frame: .zero)

            self.allowStretchAxis = stretchAxis
            let imgSize = img.size

            switch stretchAxis {
            case .unable:
                self.image = img
            case .horizontal:
                self.image = img.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                            left: imgSize.width / 2 - 1,
                                                                            bottom: 0,
                                                                            right: imgSize.width / 2),
                                                resizingMode: .stretch)
            case .horizontalAndVertical:
                self.image = img.resizableImage(withCapInsets: UIEdgeInsets(top: imgSize.height / 2 - 1,
                                                                            left: imgSize.width / 2 - 1,
                                                                            bottom: imgSize.height / 2,
                                                                            right: imgSize.width / 2),
                                                resizingMode: .stretch)
            }
            // 设置图片 不自动裁剪
            clipsToBounds = false
        }

        init(color: UIColor) {
            super.init(frame: .zero)
            bgColor(color)
            // 颜色的 自动裁圆角
            clipsToBounds = true
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public var intrinsicContentSize: CGSize {
            if let img = self.image {
                switch self.allowStretchAxis {
                case .unable:
                    return img.size
                case .horizontal:
                    let size = self.textLabel.intrinsicContentSize
                    return CGSize(width: max(size.width, size.height) + self.padding.left + self.padding.right,
                                  height: img.size.height)
                case .horizontalAndVertical:
                    let size = self.textLabel.intrinsicContentSize
                    return CGSize(width: max(size.width, size.height) + self.padding.left + self.padding.right,
                                  height: size.height + self.padding.top + self.padding.bottom)
                }
            }
            let size = self.textLabel.intrinsicContentSize
            return CGSize(width: max(size.width, size.height) + self.padding.left + self.padding.right,
                          height: size.height + self.padding.top + self.padding.bottom)
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            self.textLabel.frame = self.bounds.inset(by: self.padding)
        }
    }
}

import Combine

@available(iOS 13.0, *)
public extension XYZBadgeView {
    /// 将此 XYZBadgeView 实例与 XYZBadgeManager 中的一个路径进行绑定。
    /// 绑定后，该角标将自动根据路径的值显示、隐藏或更新数字。
    ///
    /// - Parameters:
    ///   - path: 要绑定的红点路径。
    ///   - manager: 使用的 XYZBadgeManager 实例，默认为单例。
    func bind(to path: XYZBadgePath, manager: XYZBadgeManager) {
        // 创建或更新订阅
        // 当调用此方法时，会自动取消上一个订阅
        self.subjection = manager.publisher(for: path)
            .receive(on: DispatchQueue.main) // 确保在主线程更新UI
            .sink { [weak self] value in
                self?.updateView(with: value)
            }
    }

    /// 解除当前角标的路径绑定。
    func unbind() {
        self.subjection?.cancel()
        self.subjection = nil
    }

    // MARK: - Private Helpers

    /// 根据接收到的值更新视图
    private func updateView(with value: Int) {
        if value > 0 {
            self.isHidden = false
            self.contentView.text = "\(value)"
        } else {
            // 当值为0或更少时，隐藏角标并清空文本
            self.isHidden = true
            self.contentView.text = ""
        }
    }

    /// 使用关联对象来存储订阅的Cancellable
    private var subjection: AnyCancellable? {
        get {
            objc_getAssociatedObject(self, &_cancellableKey_) as? AnyCancellable
        }
        set {
            // 在设置新值之前，确保存储的旧订阅被取消
            (objc_getAssociatedObject(self, &_cancellableKey_) as? AnyCancellable)?.cancel()
            objc_setAssociatedObject(self, &_cancellableKey_, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// 用于通过关联对象存储 Combine 的订阅
private var _cancellableKey_: Void?

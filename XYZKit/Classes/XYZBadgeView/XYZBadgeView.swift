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
        contentView = bg
        super.init(frame: .zero)
        addSubview(contentView)
        clipsToBounds = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        let size = contentView.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds.inset(by: padding)
        contentView.layer.cornerRadius = contentView.bounds.height / 2
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
                textLabel.font = font
                self.superview?.invalidateIntrinsicContentSize()
            }
        }

        public var text = "" {
            didSet {
                textLabel.text = text
                self.superview?.invalidateIntrinsicContentSize()
            }
        }

        public var textColor = UIColor.white {
            didSet {
                textLabel.textColor = textColor
            }
        }

        private lazy var textLabel: UILabel = {
            let label = UILabel().font(font).textColor(textColor).textAlignment(.center)
            addSubview(label)
            return label
        }()

        private var allowStretchAxis = BadgeBgImgStretchAxis.horizontalAndVertical

        init(img: UIImage, stretchAxis: BadgeBgImgStretchAxis) {
            super.init(frame: .zero)

            allowStretchAxis = stretchAxis
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
            clipsToBounds = false
        }

        init(color: UIColor) {
            super.init(frame: .zero)
            bgColor(color)
            clipsToBounds = true
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public var intrinsicContentSize: CGSize {
            if let img = self.image {
                switch allowStretchAxis {
                case .unable:
                    return img.size
                case .horizontal:
                    let size = textLabel.intrinsicContentSize
                    return CGSize(width: max(size.width, size.height) + padding.left + padding.right,
                                  height: img.size.height)
                case .horizontalAndVertical:
                    let size = textLabel.intrinsicContentSize
                    return CGSize(width: max(size.width, size.height) + padding.left + padding.right,
                                  height: size.height + padding.top + padding.bottom)
                }
            }
            let size = textLabel.intrinsicContentSize
            return CGSize(width: max(size.width, size.height) + padding.left + padding.right,
                          height: size.height + padding.top + padding.bottom)
        }

        override public func layoutSubviews() {
            super.layoutSubviews()
            textLabel.frame = self.bounds.inset(by: padding)
        }
    }
}

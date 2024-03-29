//
//  UIImageView+XYZ.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit

public extension UIImageView {
    convenience init(image: UIImage? = nil, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(frame: CGRect.zero)

        self.image = image
        self.contentMode = contentMode
    }

    @discardableResult
    func image(_ img: UIImage?) -> Self {
        self.image = img
        return self
    }

    @discardableResult
    func fillMode(_ cntMode: UIView.ContentMode) -> Self {
        self.contentMode = cntMode
        return self
    }
}

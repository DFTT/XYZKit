//
//  UIViewController+XYZ.swift
//  XYZKit
//
//  Created by 大大东 on 2024/2/2.
//

import Foundation

public extension UIViewController {
    /// SwifterSwift: Check if ViewController is onscreen and not hidden.
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }
}

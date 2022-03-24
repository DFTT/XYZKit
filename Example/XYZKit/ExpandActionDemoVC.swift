//
//  ExpandActionDemoVC.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2022/3/24.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ExpandActionDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bgColor(.white)

        let btn = UIButton(type: .system).bgColor(.red)
            .title("点我", for: .normal)
            .title("高亮啦", for: .highlighted)

        btn.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        btn.expandInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        self.view.addSubview(btn)

        let tview = UIView(frame: CGRect(x: 100, y: 210, width: 100, height: 100)).bgColor(.blue)
        tview.expandInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        tview.addTapGesture {
            tview.bgColor(UIColor.randomColor())
        }
        self.view.addSubview(tview)
    }
}

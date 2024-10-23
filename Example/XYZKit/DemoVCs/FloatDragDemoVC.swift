//
//  FloatDragDemoVC.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2021/11/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import XYZKit


class FloatDragDemoVC: UIViewController {
    private var floatView: XYZFloatDragView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.bgColor(.white)
        
        let right = UIBarButtonItem(title: "切换吸边模式", style: UIBarButtonItem.Style.plain, target: self, action: #selector(switchStyle))
        self.navigationItem.rightBarButtonItem = right

        
        floatView = XYZFloatDragView(frame: CGRect(x: 300, y: 350, width: 100, height: 100)).bgColor(UIColor.red)
        floatView.dockEdges = UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 30)
        self.view.addSubview(floatView)
        floatView.addTapGesture {
            print("点击事件")
        }
        updateTitle()
    }
    
    @objc func switchStyle() {
        // 随机修改
        floatView.dock = XYZFloatDragView.DockDirection(rawValue: (floatView.dock.rawValue + 1) % 3)!
        updateTitle()
    }
    
    func updateTitle() {
        
        let val = floatView.dock.rawValue
        if val == 0 {
            self.navigationItem.rightBarButtonItem?.title = "切换: 吸左面"
        }else if val == 1 {
            self.navigationItem.rightBarButtonItem?.title = "切换: 吸右面"
        }else if val == 2 {
            self.navigationItem.rightBarButtonItem?.title = "切换: 吸最近的(横向)"
        }
    }
}

//
//  GradientViewDemoVC.swift
//  XYZKit_Example
//
//  Created by songxin on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import XYZKit

class GradientViewDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
//        let btn1 = UIButton(type: .custom)
//            .title("点我都发来的建芳啦结束啦大家垃圾了", for: .normal)
//        btn1.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        ////        btn1.addGradientForTitle(.horizontal, [UIColor.red.cgColor, UIColor.blue.cgColor], [0, 1])
//        self.view.addSubview(btn1)
//
//        let btn2 = UIButton(type: .custom)
//            .title("Hello world", for: .normal)
//        btn2.frame = CGRect(x: 100, y: 350, width: 100, height: 100)
        ////        btn2.addGradientLayerForBg(.vertical, [UIColor.purple.cgColor, UIColor.brown.cgColor])
//        self.view.addSubview(btn2)
//
//        let view1 = UIView()
//        view1.frame = CGRect(x: 100, y: 500, width: 100, height: 100)
        ////        view1.addGradientLayer(.vertical, [UIColor.yellow.cgColor, UIColor.gray.cgColor])
//        self.view.addSubview(view1)
//
        
        // 渐变layer
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 10, y: 100, width: 100, height: 100)
        layer.gradient(colors: [UIColor.random().cgColor, UIColor.random().cgColor, UIColor.random().cgColor])
        self.view.layer.addSublayer(layer)
        
        let layer2 = CAGradientLayer()
        layer2.frame = CGRect(x: 120, y: 100, width: 100, height: 100)
        layer2.gradient(.linear(start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 1, y: 1)), colors: [UIColor.random().cgColor, UIColor.random().cgColor])
        layer2.type = CAGradientLayerType.radial
        layer2.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.addSublayer(layer2)
        
        let layer3 = CAGradientLayer()
        layer3.frame = CGRect(x: 230, y: 100, width: 100, height: 100)
        layer2.gradient(.linear(start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 1, y: 1)), colors: [UIColor.random().cgColor, UIColor.random().cgColor, UIColor.random().cgColor])
        layer3.type = CAGradientLayerType.conic
        layer3.startPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.addSublayer(layer3)
        
        // 渐变view
        let view = XYZGradientView(frame: CGRect(x: 100, y: 220, width: 200, height: 100))
        view.colors = [UIColor.red, UIColor.green, UIColor.blue]
        self.view.addSubview(view)
        
        // 径向渐变view 仅双色
        let view2 = XYZGradientView(frame: CGRect(x: 100, y: 340, width: 200, height: 200))
        view2.direction = .radial(start: CGPoint(x: 0, y: 0), startRadius: 0, end: CGPoint(x: 1, y: 1), endRadius: sqrt(200*200*2))
        view2.colors = [UIColor.red, UIColor.green]
        self.view.addSubview(view2)
    }
}

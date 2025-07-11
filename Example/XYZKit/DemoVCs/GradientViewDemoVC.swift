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
        layer.gradient(colors: [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor])
        self.view.layer.addSublayer(layer)
        
        let layer2 = CAGradientLayer()
        layer2.frame = CGRect(x: 120, y: 100, width: 100, height: 100)
        layer2.radialGradient(colors: [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor])
        self.view.layer.addSublayer(layer2)
        
        let layer3 = CAGradientLayer()
        layer3.frame = CGRect(x: 230, y: 100, width: 100, height: 100)
        layer3.conicGradient(colors: [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor])
        self.view.layer.addSublayer(layer3)
        
        // 渐变view
        let view = XYZGradientView(frame: CGRect(x: 10, y: 220, width: 200, height: 100))
        view.colors = [UIColor.red, UIColor.green, UIColor.blue]
        self.view.addSubview(view)
        
        // 圆锥渐变view 仅双色
        let view2 = XYZGradientView(frame: CGRect(x: 10, y: 340, width: 150, height: 150))
        view2.type = .conic
        view2.direction = .linear(start: CGPoint(x: 0.5, y: 0.5), end: CGPoint(x: 0.5, y: 1))
        view2.colors = [UIColor.red, UIColor.green, UIColor.blue]
        self.view.addSubview(view2)
        
        // 透明渐变view
        let bg = UILabel(frame: CGRect(x: 10, y: 510, width: 200, height: 80))
        bg.text = "我是一个文字背景, 我的背景色是白色, 我上面有一个 透明到白色的渐变遮罩,"
        bg.numberOfLines = 0
//        bg.backgroundColor = .red
        self.view.addSubview(bg)

        let view3 = XYZGradientView(frame: CGRect(x: 0, y: 30, width: 200, height: 50))
        view3.direction = .vertical
        view3.locations = [0, 0.9]
        view3.colors = [UIColor.white.withAlphaComponent(0), UIColor.white]
        bg.addSubview(view3)
        
        let view5 = UIImageView(frame: CGRect(x: 220, y: 510, width: 180, height: 100))
        self.view.addSubview(view5)
        var img: UIImage? = UIImage.image(with: .red, size: CGSizeMake(90, 50))
        img = img?.roundCornerRadius(radius: 50, corners: [.topRight, .bottomLeft, .bottomRight], borderWidth: 2, borderColor: .blue)
        view5.image = img
        
        let view6 = UIImageView(frame: CGRect(x: 220, y: 620, width: 180, height: 100))
        self.view.addSubview(view6)
        var img2: UIImage? = UIImage.image(with: .red, size: CGSizeMake(90, 50))
        img2 = img2?.roundCornerRadius(radius: 25, corners: [.topLeft, .bottomRight, .topRight])
        view6.image = img2
    }
}

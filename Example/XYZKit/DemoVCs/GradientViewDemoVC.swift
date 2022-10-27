//
//  GradientViewDemoVC.swift
//  XYZKit_Example
//
//  Created by songxin on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class GradientViewDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let btn1 = UIButton(type: .custom)
            .title("点我都发来的建芳啦结束啦大家垃圾了", for: .normal)
        btn1.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
//        btn1.addGradientForTitle(.horizontal, [UIColor.red.cgColor, UIColor.blue.cgColor], [0, 1])
        self.view.addSubview(btn1)
        
        let btn2 = UIButton(type: .custom)
            .title("Hello world", for: .normal)
        btn2.frame = CGRect(x: 100, y: 350, width: 100, height: 100)
//        btn2.addGradientLayerForBg(.vertical, [UIColor.purple.cgColor, UIColor.brown.cgColor])
        self.view.addSubview(btn2)
        
        let view1 = UIView()
        view1.frame = CGRect(x: 100, y: 500, width: 100, height: 100)
//        view1.addGradientLayer(.vertical, [UIColor.yellow.cgColor, UIColor.gray.cgColor])
        self.view.addSubview(view1)
    }
}

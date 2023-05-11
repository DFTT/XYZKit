//
//  BadgeDemoVC.swift.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2021/12/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import XYZKit

class BadgeDemoVC: UIViewController {
    var badge1: XYZBadgeView!
    var badge2: XYZBadgeView!
    var badge3: XYZBadgeView!
    var badge4: XYZBadgeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        func ___addBdView(_ bg: XYZBadgeView, to view: UIView) {
            view.addSubview(bg)
            bg.translatesAutoresizingMaskIntoConstraints = false
            bg.centerYAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bg.centerXAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
        
        let view1 = UIView(frame: CGRect(x: 100, y: 100, width: 50, height: 50)).bgColor(.blue)
        self.view.addSubview(view1)

        let badge1 = XYZBadgeView(.red)
        badge1.contentView.text = "9"
        badge1.contentView.font = 14.font
        ___addBdView(badge1, to: view1)
        
        let view1_1 = UIView(frame: CGRect(x: 200, y: 100, width: 50, height: 50)).bgColor(.blue)
        self.view.addSubview(view1_1)

        let badge1_1 = XYZBadgeView(.red)
        badge1_1.contentView.text = "9"
        badge1_1.contentView.font = 14.font
        badge1_1.contentView.layer.borderWidth = 2
        badge1_1.contentView.layer.borderColor = UIColor.white.cgColor
        ___addBdView(badge1_1, to: view1_1)
        
        let view2 = UIView(frame: CGRect(x: 100, y: 200, width: 50, height: 50)).bgColor(.blue)
        self.view.addSubview(view2)
        let badge2 = XYZBadgeView(.red)
        badge2.contentView.text = "9999+"
        badge2.contentView.font = 13.fontBold
        ___addBdView(badge2, to: view2)
        
        let view3 = UIView(frame: CGRect(x: 100, y: 300, width: 50, height: 50)).bgColor(.blue)
        self.view.addSubview(view3)
        let badge3 = XYZBadgeView("badgeBGImg".image!, stretchAxis: .horizontalAndVertical)
        badge3.contentView.text = "哈哈哈哈"
        badge3.contentView.font = 14.fontBold
        badge3.contentView.padding = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
        badge3.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        ___addBdView(badge3, to: view3)
        
        let view4 = UIView(frame: CGRect(x: 100, y: 400, width: 50, height: 50)).bgColor(.blue)
        self.view.addSubview(view4)
        let badge4 = XYZBadgeView(.red)
        ___addBdView(badge4, to: view4)
        
        self.badge1 = badge1
        self.badge2 = badge2
        self.badge3 = badge3
        self.badge4 = badge4
        
        
        let tip = UILabel(frame: CGRect(x: 0, y: 500, width: self.view.bounds.size.width, height: 50)).textColor(UIColor.black).text("点击屏幕试试").textAlignment(.center).font(20.font)
        self.view.addSubview(tip)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.badge1.shakeAnimation()
        self.badge2.bounceAnimation()
        
        self.badge4.swingAnimtion()
        
        self.badge3.contentView.text = arc4random() % 2 == 1 ? "哈哈哈哈" : "嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿"
    }
}

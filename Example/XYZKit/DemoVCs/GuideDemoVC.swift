//
//  GuideDemoVC.swift
//  XYZKit_Example
//
//  Created by wangwenjian on 2022/5/11.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import XYZKit

class GuideDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        _ = container
        _ = squareView
        _ = circleView
        
        DispatchQueue.main.async {
            let guide = XYZGuideView(in: self.container)
//            guide.tapHide = true // 点击 隐藏
            self.guide = guide
            self.showSquareGuide()
        }
    }
    
    weak var guide: XYZGuideView?
    
    lazy var container: UIView = {
        let v = UIView()
        view.addSubview(v)
        v.backgroundColor = 0xEEEEEE.color
        v.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            v.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            v.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            v.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            v.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ]
        NSLayoutConstraint.activate(constraints)
        return v
    }()
    
    lazy var squareView: UIButton = {
        let v = UIButton(type: .custom)
        v.backgroundColor = .blue
        v.frame = CGRect(x: 40, y: 40, width: 80, height: 80)
        v.addTapGesture { [weak self] in
            self?.guide?.clearCurrentSubs()
            self?.showCirleGuide()
        }
        container.addSubview(v)
        return v
    }()
    
    lazy var circleView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.layer.cornerRadius = 40
        v.frame = CGRect(x: 40, y: 180, width: 80, height: 80)
        container.addSubview(v)
        return v
    }()
    
    // 为方框添加指引
    func showSquareGuide() {
        guide?.show(target: self.squareView, edge: UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5), cornerRadius: 5)
        guide?.addAnnotation("arrow", offset: CGPoint(x: 60, y: 88))
        let label = UILabel()
        label.textColor = .white
        label.text = "点击这个方框"
        guide?.addAnnotation(label, offset: CGPoint(x: 60, y: 120))
    }
    
    // 为圆添加指引
    func showCirleGuide() {
        guard let guide = self.guide else {
            return
        }
        guide.show(target: self.circleView, edge: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), cornerRadius: 40)
        guide.addAnnotation("arrow", offset: CGPoint(x: 60, y: 88))
        let label = UILabel()
        label.textColor = .white
        label.text = "点击这个圆"
        guide.addAnnotation(label, offset: CGPoint(x: 60, y: 120))
    }
}

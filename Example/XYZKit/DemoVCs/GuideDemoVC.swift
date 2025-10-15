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
        view.backgroundColor = .white
        _ = container
        _ = squareView
        _ = circleView
        
        DispatchQueue.main.async {
            let guide = XYZGuideView(in: self.container)
            guide.allowTouchThroughHollow = true
            guide.clickCallback = { [weak guide] th in
                if !th {
                    guide?.dismiss()
                }
            }
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
            self?.guide?.reset()
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
        let img = UIImageView(image: "arrow".image)
        
        let label = UILabel()
        label.textColor = .white
        label.text = "点击这个方框"
        
        let ann = XYZGuideView.Annotation(with: img) { targetFrame, annotationView in
            annotationView.translatesAutoresizingMaskIntoConstraints = false
            annotationView.leftAnchor.constraint(equalTo: annotationView.superview!.leftAnchor, constant: targetFrame.maxX).isActive = true
            
            annotationView.topAnchor.constraint(equalTo: annotationView.superview!.topAnchor, constant: targetFrame.maxY).isActive = true
        }
        
        let ann2 = XYZGuideView.Annotation(with: label) { targetFrame, annotationView in
            annotationView.translatesAutoresizingMaskIntoConstraints = false
            annotationView.leftAnchor.constraint(equalTo: annotationView.superview!.leftAnchor, constant: targetFrame.maxX + 20).isActive = true
            
            annotationView.topAnchor.constraint(equalTo: annotationView.superview!.topAnchor, constant: targetFrame.maxY + 40).isActive = true
        }
        
        guide?.addHollow(for: squareView, cornerRadius: 5, insets: UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5), annotations: [ann, ann2])
        
        guide?.addHollow(for: circleView, cornerRadius: 40)

        guide?.show()
    }
    
    // 为圆添加指引
    func showCirleGuide() {
        guard let guide = guide else {
            return
        }

        let img = UIImageView(image: "arrow".image)
        
        let label = UILabel()
        label.textColor = .white
        label.text = "点击这个圆"
        
        let ann = XYZGuideView.Annotation(with: img) { targetFrame, annotationView in
            annotationView.translatesAutoresizingMaskIntoConstraints = false
            annotationView.leftAnchor.constraint(equalTo: annotationView.superview!.leftAnchor, constant: targetFrame.maxX).isActive = true
            
            annotationView.topAnchor.constraint(equalTo: annotationView.superview!.topAnchor, constant: targetFrame.maxY).isActive = true
        }
        
        let ann2 = XYZGuideView.Annotation(with: label) { targetFrame, annotationView in
            annotationView.translatesAutoresizingMaskIntoConstraints = false
            annotationView.leftAnchor.constraint(equalTo: annotationView.superview!.leftAnchor, constant: targetFrame.maxX + 20).isActive = true
            
            annotationView.topAnchor.constraint(equalTo: annotationView.superview!.topAnchor, constant: targetFrame.maxY + 40).isActive = true
        }
        
        guide.addHollow(for: circleView, cornerRadius: 5, insets: UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5), annotations: [ann, ann2])
    }
}

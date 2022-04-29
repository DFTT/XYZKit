//
//  LinkDemoVC.swift
//  XYZKit_Example
//
//  Created by wangwenjian on 2021/12/27.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import XYZKit

class LinkDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        view.addSubview(linkView)
    }
    
    lazy var linkView: XYZLinkView = {
        let linkView = XYZLinkView(frame: CGRect(x: 50, y: 200, width: 240, height: 50))
        linkView.text = "如果您对服务条款和隐私政策无异议, 请勾选我已阅读并同意服务条款和隐私政策"
        linkView.linkColor = UIColor.blue
        linkView.linkCases = ["服务条款": { [weak self] in
            print("点击 ===> 服务条款")
        }, "隐私政策": { [weak self] in
            print("点击 ===> 隐私政策")
        }]
        return linkView
    }()
}

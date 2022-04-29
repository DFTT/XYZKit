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

        let btn = UIButton(type: .system)
            .bgColor(.red)
            .title("点我右面的空白处", for: .normal)
            .titleColor(.white, for: .normal)
            .title("高亮啦", for: .highlighted)
            .font(11.font)
        btn.frame = CGRect(x: 80, y: 100, width: 100, height: 100)
        btn.expandInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        self.view.addSubview(btn)

        let tview = UIView(frame: CGRect(x: 80, y: 210, width: 100, height: 100)).bgColor(.blue)
        tview.expandInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        tview.addTapGesture {
            tview.bgColor(UIColor.randomColor())
        }
        self.view.addSubview(tview)
        
        
        //
        let leftImgBtn = UIButton(type: .custom).bgColor(.darkGray).image("btn_Icon".image, for: .normal).title("增加间距", for: .normal)
        leftImgBtn.frame = CGRect(x: 80, y: 320, width: 100, height: 100)
        view.addSubview(leftImgBtn)
        leftImgBtn.setImageTitleLayout(.imgLeft, spacing: 15)
        //
        let rightImgBtn = UIButton(type: .custom).bgColor(.orange).image("btn_Icon".image, for: .normal).title("文字在左", for: .normal)
        rightImgBtn.frame = CGRect(x: 190, y: 320, width: 100, height: 100)
        view.addSubview(rightImgBtn)
        rightImgBtn.setImageTitleLayout(.imgRight, spacing: 5)
        //
        let topImgBtn = UIButton(type: .custom).bgColor(.orange).image("btn_Icon".image, for: .normal).title("文字在下", for: .normal)
        topImgBtn.frame = CGRect(x: 80, y: 430, width: 100, height: 100)
        view.addSubview(topImgBtn)
        topImgBtn.setImageTitleLayout(.imgTop, spacing: 5)
        //
        let bottomImgBtn = UIButton(type: .custom).bgColor(.orange).image("btn_Icon".image, for: .normal).title("文字在上", for: .normal)
        bottomImgBtn.frame = CGRect(x: 190, y: 430, width: 100, height: 100)
        view.addSubview(bottomImgBtn)
        bottomImgBtn.setImageTitleLayout(.imgBottom, spacing: 20)
    }
}

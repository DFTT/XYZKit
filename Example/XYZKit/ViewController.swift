//
//  ViewController.swift
//  XYZKit
//
//  Created by dadadongl@163.com on 11/01/2021.
//  Copyright (c) 2021 dadadongl@163.com. All rights reserved.
//

import UIKit

struct VCCellItem {
    let name: String
    let vcClass: UIViewController.Type
}

class ViewController: UIViewController {
    var dataArr: [VCCellItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "demo list"
        
        dataArr.append(VCCellItem(name: "空占位视图", vcClass: EmptyBoardDemoVC.self))
        dataArr.append(VCCellItem(name: "验证码输入", vcClass: SMSCodeDemoVC.self))
        dataArr.append(VCCellItem(name: "可拖动悬浮窗", vcClass: FloatDragDemoVC.self))
        dataArr.append(VCCellItem(name: "自定义角标(小红点)", vcClass: BadgeDemoVC.self))
        dataArr.append(VCCellItem(name: "String部分区域添加可点击链接🔗", vcClass: LinkDemoVC.self))
        dataArr.append(VCCellItem(name: "UIView点击区域扩大 & btn布局", vcClass: ExpandActionDemoVC.self))
        dataArr.append(VCCellItem(name: "渐变图层(待补充???)", vcClass: GradientViewDemoVC.self))
        dataArr.append(VCCellItem(name: "新功能引导(镂空)", vcClass: GuideDemoVC.self))
        dataArr.append(VCCellItem(name: "降频buffer", vcClass: MsgBufferDemoVC.self))
        
        let tabView = UITableView(frame: self.view.bounds, style: .plain)
        tabView.delegate = self
        tabView.dataSource = self
        self.view.addSubview(tabView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idStr = "cellid"

        var cell = tableView.dequeueReusableCell(withIdentifier: idStr)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idStr)
        }
        cell!.textLabel?.text = dataArr[indexPath.row].name
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = dataArr[indexPath.row].vcClass.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

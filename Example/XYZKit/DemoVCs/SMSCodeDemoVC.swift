//
//  SMSCodeDemoVC.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/24.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit
import XYZKit

class SMSCodeDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bgColor(.white)
        
        let config1 = XYZSMSCodeInputView.Configs.default()
        let view1 = XYZSMSCodeInputView(config1)
        view1.frame = CGRect(x: 50, y: 200, width: 300, height: 60)
        view.addSubview(view1)
        view1.inputCompletion = { _ in
            // 重置输入
            view1.resetInput()
        }
        
        var config2 = XYZSMSCodeInputView.Configs.default()
        config2.codeBoder = .roundRect
        let view2 = XYZSMSCodeInputView(config2)
        view2.frame = CGRect(x: 50, y: 300, width: 300, height: 60)
        view.addSubview(view2)
        view2.inputCompletion = { _ in
            // 收键盘
            view2.endEditing(true)
        }

        var config3 = XYZSMSCodeInputView.Configs.default()
        config3.codeBoder = .rect
        config3.font = 23.fontBold
        let view3 = XYZSMSCodeInputView(config3)
        view3.frame = CGRect(x: 50, y: 400, width: 300, height: 60)
        view.addSubview(view3)
        view3.inputCompletion = { _ in
            // 收键盘
            view3.endEditing(true)
        }
        
        KeyBoardObserver.addLisenner(self)
    }
}

extension SMSCodeDemoVC: KeyBoardObserverProtocol {
    func keyboardWillChange(toRect: CGRect, toShow: Bool, duration: TimeInterval) {
        print("\(toShow) \(duration) \(toRect)")
    }
}

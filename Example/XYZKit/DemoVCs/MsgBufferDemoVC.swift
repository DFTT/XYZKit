//
//  MsgBufferDemoVC.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2022/10/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import XYZKit

class MsgBufferDemoVC: UIViewController {
    private var label1: UILabel!
    private var label2: UILabel!
    
    private var buffer: XYZMsgBuffer!
    
    private var value: Int = 0
    private var tt: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        label1 = UILabel(frame: CGRect(x: 50, y: 200, width: 100, height: 100)).textColor(.red).font(17.fontBold).textAlignment(.center).text("0").bgColor(.lightGray)
        self.view.addSubview(label1)
        
        label2 = UILabel(frame: CGRect(x: 220, y: 200, width: 100, height: 100)).textColor(.black).font(17.fontBold).textAlignment(.center).text("0").bgColor(.lightGray)
        self.view.addSubview(label2)
        
        let btn = UIButton(type: .system).title("点我开始", for: .normal).bgColor(.orange)
        btn.frame = CGRect(x: 0, y: 360, width: view.bounds.size.width, height: 50)
        btn.tapAction {[weak self] _ in
            btn.isEnabled = false
            self?.start()
        }
        self.view.addSubview(btn)
        
        buffer = XYZMsgBuffer(interval: 0.5)
        buffer.addOutPut { [weak self] msg in
            self?.label2.text = "\((Int(self?.label2.text ?? "") ?? 0) + msg.datas.count)"
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tt?.invalidate()
        tt = nil
    }
    private func start() {
        tt = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] tt in
            guard let self = self else { return }
            
            self.value += 1
            self.label1.text = "\((Int(self.label1.text ?? "") ?? 0) + 1)"
//            self.label1.text = "\(self.value)"
            
            let msg = XYZMsgBuffer.BufferMsssage(name: "name", datas: [NSNumber()])
            self.buffer.inputNewMessage(msg, coalescing: .coalescingData)
            
            if self.value > 200 {
                tt.invalidate()
            }
        }
    }
    
    deinit {
        print("vc dealloc")
    }
}

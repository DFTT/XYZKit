//
//  swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/17.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit
import XYZKit

class EmptyBoardDemoVC: UIViewController {
    private var k_number = 0
    private var count = 5
    private var boardView: XYZEmptyBoard?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let right = UIBarButtonItem(title: "切换样式", style: UIBarButtonItem.Style.plain, target: self, action: #selector(nextStyle))
        self.navigationItem.rightBarButtonItem = right
        
        nextStyle()
    }
    
    @objc func nextStyle() {
        if let bview = boardView {
            bview.removeFromSuperview()
            boardView = nil
        }

        let view = XYZEmptyBoard(frame: self.view.bounds)
        view.configImage { imageView in
            imageView.image = UIImage(named: "emotyImage")
        }
        
        if k_number % count == 1 {
            view.configDesc { label in
                label.text = "抱歉，暂无搜索结果"
            }
        }
        
        if k_number % count == 2 {
            view.configTitle { label in
                label.text = "别慌，一点小意外"
            }
            view.configDesc { label in
                label.text = "没有好友在玩，多加几个好友吧~"
            }
        }
        
        if k_number % count == 3 {
            view.configDesc { label in
                label.text = "您还没有动态哦~"
            }
            view.configBtn { btn in
                btn.title("发动态", for: .normal)
            } action: { btn in
                let random = arc4random() % 2
                if random % 3 == 0 {
                    btn.clipsCornerRadius(10).bgColor(0x17A3FC.color).titleColor(.white, for: .normal)
                    btn.layer.borderWidth = 0
                } else if random % 3 == 1 {
                    btn.clipsCornerRadius(20).bgColor(.white).titleColor(.black, for: .normal)
                    btn.layer.borderColor = UIColor.black.cgColor
                    btn.layer.borderWidth = 1
                }
            }
        }
        
        if k_number % count == 4 {
            view.configTitle { label in
                label.text = "别慌，一点小意外"
            }
            view.configDesc { label in
                label.text = "请确认网络正常后，再次刷新试试"
            }
            view.configBtn { btn in
                btn.title("刷新", for: .normal)
            } action: { btn in
                btn.clipsCornerRadius(10)
            }
        }
        
        self.view.addSubview(view)
        k_number += 1
    }
}

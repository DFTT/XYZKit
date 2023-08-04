//
//  ImgeDownSamplingDemoVC.swift
//  XYZKit_Example
//
//  Created by 大大东 on 2023/8/4.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

class ImgeDownSamplingDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let img = UIImage(named: "voice_room_bg2")

        let imgview = UIImageView(image: img)
        view.addSubview(imgview)
        imgview.frame = CGRectMake(10, 200, 150, 300)

        let imgview2 = UIImageView()
        view.addSubview(imgview2)
        imgview2.frame = CGRectMake(200, 200, 100, 200)
        let dimg2 = img?.downSamplingToViewSize(imgview2.bounds.size)
        imgview2.image = dimg2

        let imgview3 = UIImageView()
        view.addSubview(imgview3)
        imgview3.frame = CGRectMake(200, 410, 100, 200)
        let dimg3 = img?.downSamplingToViewSize(CGSizeMake(100 * UIScreen.main.scale,
                                                           200 * UIScreen.main.scale))
        imgview3.image = dimg3
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}

//
//  CALayer+XYZ.swift
//  XYZKit
//
//  Created by dadadongl on 2025/8/11.
//

import Foundation

public extension CALayer {
    // 暂停动画
    func pauseAnimation() {
        guard speed != 0.0 else { return } // 已经是暂停状态
            
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pauseTime
    }
        
    // 恢复动画
    func resumeAnimation() {
        guard speed == 0.0 else { return } // 已经是运行状态
            
        let pauseTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
            
        let startTime = convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        beginTime = startTime
    }
}

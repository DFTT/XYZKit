//
//  XYZCellLogUtil.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/5/19.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

let cellLog_min_displayTimeDuraction: Float = 1.0

// cell or cellModel need confirm this protocol
protocol CellLogParamProtocol {
    func displayParams() -> [String: AnyObject]
    func clickParams() -> [String: AnyObject]
}

class CellLoger<T: CellLogParamProtocol & Hashable> {
    var waitingConfirmItems: [T: Float]
    var items: [CellLogParamProtocol]

    private let _lock: DispatchSemaphore
    private let _queue: DispatchQueue

    init() {
        waitingConfirmItems = Dictionary()
        items = Array()
        _queue = DispatchQueue(label: "com.xyz.cellLog")
        _lock = DispatchSemaphore(value: 1)
        LogCheckTimer.instance.addTarget(self)
    }

    /// willDisplayCell 时调用
    /// - Parameter item: 实现了协议的cell或cellModel
    func addDidDispleayItem(_ item: T) {
        _queue.async {
            self._lock.wait()
            self.waitingConfirmItems.updateValue(Float(CFAbsoluteTimeGetCurrent()), forKey: item)
            self._lock.signal()
        }
    }

    /// didEndDisplayingCell 时调用
    /// - Parameter item: 实现了协议的cell或cellModel
    func removeEndDisplayItem(_ item: T) {
        _queue.async {
            self._lock.wait()
            self.waitingConfirmItems.removeValue(forKey: item)
            self._lock.signal()
        }
    }
}

extension CellLoger: LogCheckTimerAble {
    func fireRepeatAction() {
        if waitingConfirmItems.isEmpty {
            return
        }
        _queue.async {
            self._lock.wait()
            let curTime = Float(CFAbsoluteTimeGetCurrent())
            let vaildItems = self.waitingConfirmItems.filter { _, val -> Bool in
                fabsf(curTime - val) >= cellLog_min_displayTimeDuraction
            }.keys
            if !vaildItems.isEmpty {
                self.items += Array(vaildItems)
            }
            for key in vaildItems {
                self.waitingConfirmItems.removeValue(forKey: key)
            }
            self._lock.signal()
        }
    }
}

//
private protocol LogCheckTimerAble {
    func fireRepeatAction()
}

//
private class LogCheckTimer {
    static let instance = LogCheckTimer()

    private var timer: Timer?
    private var targets: [LogCheckTimerAble]

    private init() {
        targets = Array()
    }

    func addTarget(_ target: LogCheckTimerAble) {
        targets.append(target)
        start()
    }

    func removeTarget(_ target: LogCheckTimerAble) {
        for (index, obj) in targets.enumerated() {
            if obj as AnyObject === target as AnyObject {
                targets.remove(at: index)
            }
        }
    }

    private func timerRunning() -> Bool {
        if let timer = timer, timer.isValid {
            return true
        }
        return false
    }

    private func start() {
        if timerRunning() {
            return
        }
        let tm = Timer(timeInterval: TimeInterval(cellLog_min_displayTimeDuraction),
                       target: self,
                       selector: #selector(repeatAction),
                       userInfo: nil,
                       repeats: true)
        RunLoop.current.add(tm, forMode: .common)
        timer = tm
    }

    private func stop() {
        guard timerRunning() else {
            return
        }
        timer!.invalidate()
        timer = nil
    }

    @objc private func repeatAction() {
        guard !targets.isEmpty else {
            stop()
            return
        }
        for item in targets {
            item.fireRepeatAction()
        }
    }
}

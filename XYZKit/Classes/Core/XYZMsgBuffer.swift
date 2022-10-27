//
//  XYZMsgBuffer.swift
//  XYZKit
//
//  Created by 大大东 on 2022/10/13.
//

import Foundation

/// 降频缓冲器, target -> 缓冲器 -> action
/// 在中间起缓冲作用, 避免高频触发action导致的性能问题
/// 支持三种不同的策略, 对消息进行保留老的/保留新的/合并
///
///
public class XYZMsgBuffer {
    public struct BufferMsssage {
        public let name: String
        public let datas: [Any]
        public init(name: String, datas: [Any]) {
            self.name = name
            self.datas = datas
        }
    }

    public enum BufferMessageCoalescing: Int {
        case discardOld // name相同时, 覆盖老的
        case discardNest // name相同时, 丢弃新的
        case coalescingData // name相同时, 合并数据(会保持消息的先后顺序)
    }

    public typealias BufferOutputBlock = (BufferMsssage) -> Void

    /// 时间间隔
    private let interval: TimeInterval
    /// 输出源
    private var outputs = [BufferOutputBlock]()
    /// 最后一次输出的时间
    private var lastFireDate: TimeInterval = 0
    /// 尚未输出的消息数据
    private var messagesMap = [String: BufferMsssage]()
    /// 定时器
    private var delayTimer: Timer?

    public init(interval: TimeInterval) {
        self.interval = interval
    }

    deinit {
        print("buffer dealloc")
    }

    /// 添加一个输出源
    /// - Parameter out: 输出block
    public func addOutPut(_ out: @escaping BufferOutputBlock) {
        outputs.append(out)
    }

    /// 输入消息
    /// - Parameters:
    ///   - msg: 新消息
    ///   - coalescing: 合并策略
    ///   - flush: 立即输出缓冲数据, 默认false (例如: 用在im中时, 自己发送一条消息时需要立即刷新)
    public func inputNewMessage(_ msg: BufferMsssage, coalescing: BufferMessageCoalescing, flush: Bool = false) {
        DispatchQueue.main.async {
            switch coalescing {
            case .discardOld:
                self.messagesMap[msg.name] = msg
            case .discardNest:
                if self.messagesMap[msg.name] == nil {
                    self.messagesMap[msg.name] = msg
                }
            case .coalescingData:
                if let old = self.messagesMap[msg.name] {
                    var newDatas = Array(old.datas)
                    newDatas.append(contentsOf: msg.datas)
                    self.messagesMap[msg.name] = BufferMsssage(name: msg.name, datas: old.datas + msg.datas)
                } else {
                    self.messagesMap[msg.name] = msg
                }
            }

            if flush {
                self.delayTimer?.invalidate()
                self.outputFire()
            } else {
                self.tryOutput()
            }
        }
    }

    /// 尝试输出
    private func tryOutput() {
        /// 第一次 直接回调
        guard self.lastFireDate > 0 else {
            outputFire()
            return
        }

        /// 等待定时器回调
        guard self.delayTimer == nil || self.delayTimer!.isValid == false else {
            return
        }

        let intervel = min(self.interval, self.lastFireDate + self.interval - CFAbsoluteTimeGetCurrent())
        guard intervel >= 0.1 else {
            /// 已大于时间间隔 || 剩余时间过短直接回调, 太短的时间开启定时器延时回调可能不准
            delayTimer?.invalidate()
            outputFire()
            return
        }

        /// 开启延时定时器
        self.delayTimer?.invalidate()
        self.delayTimer = Timer(timeInterval: intervel, repeats: false) { [weak self] timer in
            timer.invalidate()
            self?.outputFire()
        }
        RunLoop.main.add(self.delayTimer!, forMode: .common)
    }

    /// 输出缓存中的数据
    private func outputFire() {
        let tmpMsgs = self.messagesMap
        guard tmpMsgs.isEmpty == false else { return }

        self.messagesMap.removeAll()
        self.lastFireDate = CFAbsoluteTimeGetCurrent()

        // 主线程回调
        DispatchQueue.main.async {
            tmpMsgs.values.forEach { msg in
                self.outputs.forEach { $0(msg) }
            }
            NSLog("call back")
        }
    }
}

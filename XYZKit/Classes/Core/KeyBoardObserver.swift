//
//  KeyBoardObserver.swift
//  XYZKit
//
//  Created by 大大东 on 2023/8/25.
//

import UIKit

public protocol KeyBoardObserverProtocol {
    func keyboardWillChange(toRect: CGRect, toShow: Bool, duration: TimeInterval)
}

public class KeyBoardObserver: NSObject {
    public typealias T = KeyBoardObserverProtocol & UIResponder

    public static func addLisenner(_ ner: T) {
        KeyBoardObserver.default.lisenners.add(ner)
    }

    public static func removeLisenner(_ ner: T) {
        self.default.lisenners.remove(ner)
    }

    static let `default` = KeyBoardObserver()

    var lisenners = NSHashTable<AnyObject>.weakObjects()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func kbWillShow(_ notify: Notification) {
        if let kbToRect = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = notify.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        {
            for ins in lisenners.objectEnumerator() {
                (ins as! KeyBoardObserverProtocol).keyboardWillChange(toRect: kbToRect, toShow: true, duration: duration)
            }
        }
    }

    @objc private func kbWillHidden(_ notify: Notification) {
        if let kbToRect = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let duration = notify.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        {
            for ins in lisenners.objectEnumerator() {
                (ins as! KeyBoardObserverProtocol).keyboardWillChange(toRect: kbToRect, toShow: false, duration: duration)
            }
        }
    }
}

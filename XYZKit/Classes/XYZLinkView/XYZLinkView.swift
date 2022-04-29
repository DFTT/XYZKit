//
//  XYZLinkView.swift
//  Pods-XYZKit_Example
//
//  Created by wangwenjian on 2021/12/27.
//

import Foundation

/**
 使用文本 点击 事件
 1、绑定关键词和 响应点击事件
 2、支持多组关键词
 
 已知问题待处理: 只能支持第一个命中词(比如:"如果你好,那么你好", 只能高亮第一个"你好")
 */

public class XYZLinkView: UITextView {
    public typealias LinkTapBlock = () -> Void

    public var linkCases: [String: LinkTapBlock]? {
        didSet {
            self.loadLinkTap()
        }
    }

    public var linkColor: UIColor? {
        didSet {
            guard let linkColor = linkColor else {
                return
            }
            self.linkTextAttributes = [NSAttributedString.Key.foregroundColor: linkColor]
        }
    }

    func loadLinkTap() {
        var attr: NSMutableAttributedString?
        if text != nil {
            attr = NSMutableAttributedString(string: text)
        }

        if self.attributedText != nil {
            attr = NSMutableAttributedString(attributedString: self.attributedText)
        }

        guard let linkCases = linkCases, let attr = attr else {
            return
        }
        for (_, key) in linkCases.keys.enumerated() {
            let range = NSRange(text.range(of: key)!, in: text)
            let path: String? = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if path != nil {
                attr.addAttribute(NSAttributedString.Key.link, value: "XYZLink://" + path!, range: range)
            }
        }
        self.isEditable = false
        self.attributedText = attr
        self.delegate = self
    }
}

extension XYZLinkView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "XYZLink" {
            guard let key = URL.host else {
                return false
            }
            guard let block: LinkTapBlock = linkCases?[key] else {
                return false
            }
            block()
        }
        return false
    }
    public func textViewDidChangeSelection(_ textView: UITextView) {
        // 禁止圈选
        textView.selectedRange.length = 0;
    }
}

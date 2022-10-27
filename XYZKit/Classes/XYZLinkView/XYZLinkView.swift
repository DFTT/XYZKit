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
 3、支持重复出现关键字
 */

public class XYZLinkView: UITextView {
    public typealias LinkTapBlock = () -> Void

    public var linkCases: [String: LinkTapBlock]? {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public var linkColor: UIColor? {
        didSet {
            guard let linkColor = linkColor else {
                return
            }
            self.linkTextAttributes = [NSAttributedString.Key.foregroundColor: linkColor]
            self.setNeedsDisplay()
        }
    }

    private func loadLinkTap() {
        var attr: NSMutableAttributedString?

        if self.attributedText != nil {
            attr = NSMutableAttributedString(attributedString: self.attributedText)
        } else if text != nil {
            attr = NSMutableAttributedString(string: text)
        }

        guard let linkCases = linkCases, let attr = attr else {
            return
        }
        for (_, key) in linkCases.keys.enumerated() {
            let ranges: [NSRange] = text.kmpFindAll(key) // 查找所有子字符串 Range
            let path: String? = key.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if path != nil {
                for range in ranges {
                    attr.addAttribute(NSAttributedString.Key.link, value: "XYZLink://" + path!, range: range)
                }
            }
        }
        self.isEditable = false
        self.attributedText = attr
        self.delegate = self
    }

    override public func draw(_ rect: CGRect) {
        loadLinkTap()
        super.draw(rect)
    }
}

extension XYZLinkView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "XYZLink", let key = URL.host, let block = linkCases?[key] {
            block()
        }
        return false
    }

    public func textViewDidChangeSelection(_ textView: UITextView) {
        // 禁止圈选
        textView.selectedRange.length = 0
    }
}

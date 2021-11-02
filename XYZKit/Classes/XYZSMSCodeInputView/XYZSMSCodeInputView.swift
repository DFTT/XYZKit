//
//  XYZSMSCodeInputView.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/24.
//  Copyright © 2021 大大东. All rights reserved.
//

import UIKit

public class XYZSMSCodeInputView: UIView {
    public struct Configs {
        public enum CodeBoderStyle: Int {
            case bottomLine
            case rect
            case roundRect
        }

        public var count: Int = 4
        public var font: UIFont = 17.fontMedium
        public var textColor: UIColor = .black
        public var spacing: Float = 20
        public var codeBoderColor: UIColor = 0xe2e3e6.color
        public var codeBoder: CodeBoderStyle = .bottomLine
        public var curserColor: UIColor = .systemBlue
        public var codeSelectedBoderColor: UIColor = .red

        public static func `default`() -> Self {
            return self.init()
        }
    }

    public var code: String {
        return textField.text ?? ""
    }

    public var inputCompletion: ((_: String) -> Void)?

    public private(set) var config: Configs

    public init(_ cfg: Configs) {
        config = cfg
        super.init(frame: CGRect.zero)

        let tf = textField
        addSubview(textField)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tf.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tf.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tf.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let stackV = stackView
        stackV.spacing = CGFloat(config.spacing)
        addSubview(stackV)
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackV.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        stackV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        codeLabels.forEach { label in
            stackV.addArrangedSubview(label)
        }

        let cs = XYZCurser(color: config.curserColor)
        self.addSubview(cs)
        cs.beginAnimation()
        curser = cs
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func resetInput() {
        textField.text = ""
        codeLabels.forEach { $0.text = "" }
        updateSelectIndex(0)
        if !textField.isFirstResponder {
            tmpRemoveSelectStyle()
        }
    }

    private var curser: XYZCurser?
    private var selectIndex: Int = 0

    private lazy var codeLabels: [XYZCodeLabel] = {
        var array = [XYZCodeLabel]()
        for i in 1 ... config.count {
            let label = XYZCodeLabel(boderStyle: config.codeBoder,
                                     boderNomalColor: config.codeBoderColor,
                                     boderSelectedColor: config.codeSelectedBoderColor)
            label.font(config.font).textColor(config.textColor)
            array.append(label)

            label.tag = i - 1
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapgesAction(_:)))
            label.addGestureRecognizer(tap)
        }
        return array
    }()

    private lazy var stackView: UIStackView = {
        let stackV = UIStackView()
        stackV.axis = .horizontal
        stackV.distribution = .fillEqually
        stackV.alignment = .fill
        return stackV
    }()

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.backgroundColor = .clear
        tf.tintColor = .clear
        tf.textColor = .clear
        tf.delegate = self
        return tf
    }()

    @objc private func labelTapgesAction(_ tap: UITapGestureRecognizer) {
        textField.becomeFirstResponder()
//        guard let index = tap.view?.tag else {
//            return
//        }
//        if index <= self.selectIndex {
//            updateSelectIndex(index)
//        }
    }

    private func fillCode(_ str: String, toindex index: Int) -> Bool {
        guard index < codeLabels.count else {
            return false
        }
        codeLabels[index].text = str
        DispatchQueue.main.async {
            // 区分删除或者增加
            self.updateSelectIndex(str.isEmpty ? index : index + 1)
        }
        return true
    }

    private func updateSelectIndex(_ index: Int) {
        tmpRemoveSelectStyle()

        guard index < codeLabels.count else {
            DispatchQueue.main.async {
                // 输入满了
                self.inputCompletion?(self.code)
            }
            return
        }
        self.selectIndex = index
        codeLabels[index].selected = true

        let frame = codeLabels[index].frame
        if frame != .zero {
            let height = config.font.capHeight * 1.2
            curser?.frame = CGRect(x: frame.origin.x + (frame.size.width - 2) / 2, y: (frame.size.height - height) / 2, width: 2, height: height)
            curser?.isHidden = false
        }
    }

    private func tmpRemoveSelectStyle() {
        curser?.isHidden = true
        codeLabels[selectIndex].selected = false
    }
}

extension XYZSMSCodeInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return fillCode(string, toindex: range.location)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSelectIndex(self.selectIndex)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        tmpRemoveSelectStyle()
    }

    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        tmpRemoveSelectStyle()
    }
}

private class XYZCodeLabel: UILabel {
    var selected: Bool = false {
        didSet {
            refreshUI()
        }
    }

    private let boderStyle: XYZSMSCodeInputView.Configs.CodeBoderStyle?
    private let boderNomalColor: UIColor?
    private let boderSelectedColor: UIColor?

    init(boderStyle: XYZSMSCodeInputView.Configs.CodeBoderStyle?,
         boderNomalColor: UIColor?,
         boderSelectedColor: UIColor?)
    {
        self.boderStyle = boderStyle
        self.boderNomalColor = boderNomalColor
        self.boderSelectedColor = boderSelectedColor
        super.init(frame: CGRect.zero)
        self.textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshUI()
    }

    private var boderLayer: CALayer?

    private func refreshUI() {
        guard let style = boderStyle else {
            return
        }
        let size = self.bounds.size
        guard size != .zero else {
            return
        }
        if boderLayer == nil {
            boderLayer = CALayer()
            boderLayer!.borderWidth = 1
        }
        let layer = boderLayer!
        switch style {
        case .bottomLine:
            layer.frame = CGRect(x: 0, y: size.height - 1, width: size.width, height: 1)
            layer.masksToBounds = false
            layer.cornerRadius = 0
            layer.borderColor = nil
            layer.borderColor = selected ? boderSelectedColor?.cgColor : boderNomalColor?.cgColor

        case .rect:
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.masksToBounds = false
            layer.cornerRadius = 0
            layer.borderColor = selected ? boderSelectedColor?.cgColor : boderNomalColor?.cgColor

        case .roundRect:
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.masksToBounds = true
            layer.cornerRadius = size.height / 5
            layer.borderColor = selected ? boderSelectedColor?.cgColor : boderNomalColor?.cgColor
        }
        self.layer.addSublayer(layer)
    }
}

private class XYZCurser: UIView {
    private var lightAnimation: CAAnimation?
    private let animateColor: UIColor
    init(color: UIColor = .systemBlue) {
        animateColor = color
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginAnimation() {
        guard lightAnimation == nil else {
            return
        }
        let animate = CABasicAnimation(keyPath: "backgroundColor")
        animate.fromValue = UIColor.clear.cgColor
        animate.toValue = animateColor.cgColor
        animate.duration = 1
        animate.repeatCount = Float(INT_MAX)
        self.layer.add(animate, forKey: "_hahaha_")
        lightAnimation = animate
    }

    func endAnimation() {
        guard lightAnimation != nil else {
            return
        }
        self.layer.removeAnimation(forKey: "_hahaha_")
        lightAnimation = nil
    }
}

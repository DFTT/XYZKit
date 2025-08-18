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
        public enum CodeBoderStyle {
            case bottomLine
            case rect
            case roundRect(cornerRadius: CGFloat = 12)
        }

        public enum BorderHighlightMode: Int {
            case select // 当前选中的高亮
            case fill // 填充后的都高亮
        }

        public var count: Int = 4
        public var font: UIFont = 17.fontMedium
        public var textColor: UIColor = .black
        public var spacing: Float = 20
        // 边框线宽
        public var codeBoderLineWidth: Float = 1
        // 边框颜色
        public var codeBoderColor: UIColor = 0xe2e3e6.color
        // 边框高亮颜色
        public var codeSelectedBoderColor: UIColor = .red
        // 边框样式
        public var codeBoder: CodeBoderStyle = .bottomLine
        // 边框高亮模式
        public var boderColorStyle: BorderHighlightMode = .select
        // 光标颜色
        public var cursorColor: UIColor = .systemBlue

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
        tf.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tf.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tf.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tf.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let stackV = stackView
        stackV.spacing = CGFloat(config.spacing)
        addSubview(stackV)
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackV.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackV.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        for label in codeLabels {
            stackV.addArrangedSubview(label)
        }

        let cs = XYZCursorView()
        cs.color = config.cursorColor
        addSubview(cs)
        cs.startBlinking()
        cursor = cs
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func becomeFirstResponder() -> Bool {
        let res = super.becomeFirstResponder()
        textField.becomeFirstResponder()
        return res
    }

    override public func resignFirstResponder() -> Bool {
        let res = super.resignFirstResponder()
        textField.resignFirstResponder()
        return res
    }

    public func resetInput() {
        textField.text = ""
        codeLabels.forEach { $0.text = "" }
        updateSelectIndex(0)
        if !textField.isFirstResponder {
            tmpRemoveSelectStyle()
        }
    }

    private var cursor: XYZCursorView?
    private var selectIndex: Int = 0

    private lazy var codeLabels: [XYZCodeLabel] = {
        var array = [XYZCodeLabel]()
        for i in 1 ... config.count {
            let label = XYZCodeLabel(boderStyle: config.codeBoder,
                                     boderLineWidth: CGFloat(config.codeBoderLineWidth),
                                     boderNomalColor: config.codeBoderColor,
                                     boderSelectedColor: config.codeSelectedBoderColor,
                                     borderHighlightStyle: config.boderColorStyle)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // 输入满了
                self.inputCompletion?(self.code)
            }
            return
        }
        selectIndex = index
        codeLabels[index].selected = true

        let targetLabel = codeLabels[index]

        // 已经填充内容的 不显示光标
        if let txt = targetLabel.text, txt.isEmpty == false {
            cursor?.isHidden = true
            return
        }

        // 显示光标
        let frame = targetLabel.frame
        if frame != .zero {
            let height = config.font.capHeight * CGFloat(1.2)
            cursor?.frame = CGRect(x: frame.midX - 1,
                                   y: frame.midY - height / 2,
                                   width: 2,
                                   height: height)
            cursor?.isHidden = false
        }
    }

    private func tmpRemoveSelectStyle() {
        cursor?.isHidden = true
        codeLabels[selectIndex].selected = false
    }
}

extension XYZSMSCodeInputView: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return fillCode(string, toindex: range.location)
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateSelectIndex(selectIndex)
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

    private let boderStyle: XYZSMSCodeInputView.Configs.CodeBoderStyle
    private let boderLineWidth: CGFloat
    private let boderNomalColor: UIColor
    private let boderSelectedColor: UIColor
    private let borderHighlightStyle: XYZSMSCodeInputView.Configs.BorderHighlightMode

    init(boderStyle: XYZSMSCodeInputView.Configs.CodeBoderStyle,
         boderLineWidth: CGFloat,
         boderNomalColor: UIColor,
         boderSelectedColor: UIColor,
         borderHighlightStyle: XYZSMSCodeInputView.Configs.BorderHighlightMode)
    {
        self.boderStyle = boderStyle
        self.boderLineWidth = boderLineWidth
        self.boderNomalColor = boderNomalColor
        self.boderSelectedColor = boderSelectedColor
        self.borderHighlightStyle = borderHighlightStyle
        super.init(frame: CGRect.zero)
        textAlignment = .center
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
        let size = bounds.size
        guard size != .zero else {
            return
        }
        if boderLayer == nil {
            boderLayer = CALayer()
            boderLayer!.borderWidth = boderLineWidth
        }
        let layer = boderLayer!
        switch boderStyle {
        case .bottomLine:
            layer.frame = CGRect(x: 0, y: size.height - boderLineWidth, width: size.width, height: boderLineWidth)
            layer.masksToBounds = false
            layer.cornerRadius = 0
            layer.borderColor = nil

        case .rect:
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.masksToBounds = false
            layer.cornerRadius = 0

        case .roundRect(let cornerRadius):
            layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }

        switch borderHighlightStyle {
        case .select:
            layer.borderColor = selected ? boderSelectedColor.cgColor : boderNomalColor.cgColor
        case .fill:
            layer.borderColor = (text?.isEmpty == false || selected) ? boderSelectedColor.cgColor : boderNomalColor.cgColor
        }
        self.layer.addSublayer(layer)
    }
}

private class XYZCursorView: UIView {
    /// 光标颜色，默认系统蓝色
    var color: UIColor = .systemBlue {
        didSet {
            backgroundColor = color
        }
    }

    /// 闪烁间隔时间（秒）
    var blinkInterval: TimeInterval = 0.5 {
        didSet {
            if isBlinking {
                stopBlinking()
                startBlinking()
            }
        }
    }

    /// 是否正在闪烁
    private(set) var isBlinking: Bool = false

    private var blinkAnimation: CABasicAnimation?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    deinit {
        stopBlinking()
    }

    private func setup() {
        backgroundColor = color
        layer.opacity = 0.0
        isUserInteractionEnabled = false // 不拦截触摸事件
    }

    /// 开始闪烁动画
    func startBlinking() {
        guard !isBlinking else { return }
        isBlinking = true

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.duration = blinkInterval
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        layer.add(animation, forKey: "cursorBlink")
        blinkAnimation = animation
    }

    /// 停止闪烁动画
    func stopBlinking() {
        guard isBlinking else { return }
        isBlinking = false

        layer.removeAnimation(forKey: "cursorBlink")
        layer.opacity = 0.0
        blinkAnimation = nil
    }

    /// 立即显示光标（不闪烁）
    func show() {
        stopBlinking()
        layer.opacity = 1.0
    }

    /// 立即隐藏光标
    func hide() {
        stopBlinking()
        layer.opacity = 0.0
    }
}

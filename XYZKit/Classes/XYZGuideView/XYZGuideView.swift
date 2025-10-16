//
//  XYZGuideView.swift
//  XYZKit
//
//  Created by dadadongl on 2025/10/15.
//
import UIKit

public final class XYZGuideView: UIView {
    public struct Annotation {
        let view: UIView
        let makeConstraintsBlock: (_ targetFrame: CGRect, _ annotationView: UIView) -> Void
        
        // targetFrame是对应镂空区域的frame, 根据此frame, 请在blcok中对annotationView添加相对于父视图的约束以控制标注视图位置
        public init(with view: UIView,
                    makeConstraints block: @escaping (_ targetFrame: CGRect, _ annotationView: UIView) -> Void)
        {
            self.view = view
            self.makeConstraintsBlock = block
        }
    }
    
    // MARK: - 属性
  
    public var allowTouchThroughHollow: Bool = true
    
    /// 点击回调, 可是区分是否是点击在穿透区域, 自行控制关闭引导或是重置为下一步引导
    public var clickCallback: ((_ inHollowArea: Bool) -> Void)?
    
    // MARK: - 初始化
    
    public init(in view: UIView) {
        self.hostView = view
        super.init(frame: view.bounds)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 公开
    
    /// 添加镂空区域（通过视图）
    public func addHollow(for view: UIView, cornerRadius: CGFloat = 0, insets: UIEdgeInsets = .zero, annotations: [Annotation] = []) {
        guard let hostView = hostView else { return }
        let frame = view.convert(view.bounds, to: hostView)
        addHollow(rect: frame, cornerRadius: cornerRadius, insets: insets, annotations: annotations)
    }
    
    /// 添加镂空区域（通过Rect）
    public func addHollow(rect: CGRect, cornerRadius: CGFloat = 0, insets: UIEdgeInsets = .zero, annotations: [Annotation] = []) {
        guard rect.isEmpty == false else { return }
        
        _hollowRects.append((rect.inset(by: insets), cornerRadius))
        _annotations.append(contentsOf: annotations)
        // 添加标注
        for annotation in annotations {
            addSubview(annotation.view)
            annotation.makeConstraintsBlock(rect, annotation.view)
        }
        updateMask()
    }
    
    /// 重置引导
    public func reset() {
        _hollowRects.removeAll()
        maskLayer.path = UIBezierPath(rect: bounds).cgPath
        
        _annotations.forEach { $0.view.removeFromSuperview() }
        _annotations.removeAll()
    }
    
    public func show(animated: Bool = true) {
        guard let hostView = hostView else { return }

        alpha = 0
        hostView.addSubview(self)

        let animations = { self.alpha = 1 }
        animated ? UIView.animate(withDuration: 0.2, animations: animations) : animations()
    }

    /// 隐藏引导
    public func dismiss(animated: Bool = true) {
        let animations = {
            self.alpha = 0
        }
        
        let completion: (Bool) -> Void = { _ in
            self.removeFromSuperview()
            self.reset()
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.2,
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
    }
    
    // MARK: - 私有

    private weak var hostView: UIView?
    private var _hollowRects: [(rect: CGRect, cornerRadius: CGFloat)] = []
    private var _annotations: [Annotation] = []
    
    private var lastEventTimestamp: TimeInterval = -1
    
    private lazy var maskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        return layer
    }()
    
    private func setup() {
        backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        layer.mask = maskLayer
    }

    private func updateMask() {
        let path = UIBezierPath(rect: bounds)
        
        for (hollowRect, cornerRadius) in _hollowRects {
            let hollowPath = UIBezierPath(roundedRect: hollowRect, cornerRadius: cornerRadius)
            path.append(hollowPath.reversing())
        }
        
        maskLayer.path = path.cgPath
    }
    
    // MARK: - 点击穿透
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let res = super.hitTest(point, with: event) else {
            return nil
        }
        // 不是子视图 & 可以穿透, 再判断是否在镂空区域
        if res === self {
            let currentTimestamp = event?.timestamp ?? 0
            // 只处理新的事件
            if currentTimestamp != lastEventTimestamp {
                lastEventTimestamp = currentTimestamp
                
                if allowTouchThroughHollow {
                    for (rect, _) in _hollowRects {
                        if rect.contains(point) {
                            clickCallback?(true)
                            return nil
                        }
                    }
                }
                clickCallback?(false)
            }
        }
        return res
    }
}

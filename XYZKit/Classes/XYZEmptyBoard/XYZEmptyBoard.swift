//
//  XYZEmptyBoard.swift
//  SwiftLearnDemo
//
//  Created by 大大东 on 2021/9/13.
//  Copyright © 2021 大大东. All rights reserved.
//

import Foundation

/*
  __________________
 |                  |
 |      image       |
 |      title       |
 |    description   |
 |     (button)     |
 |                  |
  ------------------
 UI样式如上, 提供了默认的模板布局 (和美术约定的布局, 业务无需修改吗, 配置使用即可)
 根据需要调用 -configxxx 即可显示对应子控件
 初始化后 自行添加到目标父视图中
  */
public class XYZEmptyBoard: UIView {
    public func configImage(_ block: (_: UIImageView) -> Void) {
        views.imgView.isHidden = false
        block(views.imgView)
    }

    public func configTitle(_ block: (_: UILabel) -> Void) {
        views.titleLabel.isHidden = false
        block(views.titleLabel)
    }
    
    public func configDesc(_ block: (_: UILabel) -> Void) {
        views.desLabel.isHidden = false
        block(views.desLabel)
    }
    
    public func configBtn(_ block: (_: UIButton) -> Void, action: @escaping (_: UIButton) -> Void) {
        block(self.btn)
        self.btnAcitonBlock = action
    }
    
    // MARK: - override
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private

    private var btnAcitonBlock: ((_: UIButton) -> Void)?
    
    private lazy var btn: UIButton = {
        let btn = UIButton(type: .custom).clipsCornerRadius(20).bgColor(0x17A3FC.color).titleColor(.white, for: .normal)
        self.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(greaterThanOrEqualToConstant: 95).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btn.topAnchor.constraint(equalTo: views.stackView.bottomAnchor, constant: 30).isActive = true
        btn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        btn.addTarget(self, action: #selector(btnClickAction), for: .touchUpInside)
        return btn
    }()

    private lazy var views: (stackView: UIStackView, imgView: UIImageView, titleLabel: UILabel, desLabel: UILabel) = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        let imgV = UIImageView(contentMode: .scaleAspectFill)
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imgV.heightAnchor.constraint(equalToConstant: 180).isActive = true
        imgV.isHidden = true

        let titleL = UILabel().font(16.fontMedium).textColor(.black).textAlignment(.center).numberOfLines(2)
        titleL.isHidden = true
        
        let descL = UILabel().font(15.fontMedium).textColor(0x9F9F9F.color).textAlignment(.center).numberOfLines(0)
        descL.isHidden = true
        
        stackView.addArrangedSubview(imgV)
        stackView.addArrangedSubview(titleL)
        stackView.addArrangedSubview(descL)
        
        return (stackView, imgV, titleL, descL)
    }()
    
    @objc private func btnClickAction() {
        self.btnAcitonBlock?(btn)
    }
}

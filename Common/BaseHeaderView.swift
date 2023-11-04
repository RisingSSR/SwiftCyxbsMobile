//
//  BaseHeaderView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/11/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

open class BaseHeaderView: UIView {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backControl)
        addSubview(titleLabel)
        addSubview(lineView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var myBackBtn: UIButton = {
        let btn = UIButton()
        let space: CGFloat = 15
        btn.frame.origin = CGPoint(x: space, y: Constants.statusBarHeight + space)
        btn.frame.size = CGSize(width: 30, height: 30)
        let img = UIImage(named: "direction_left")?
            .tint(.ry(light: "#112C54", dark: "#F0F0F2"), blendMode: .destinationIn)
            .scaled(toHeight: 20)
        btn.setImage(img, for: .normal)
        btn.addTarget(self, action: #selector(touchUpInside(myBackBtn:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var myTitleLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 22, weight: .semibold)
        lab.textColor = .ry(light: "#112C54", dark: "#F0F0F2")
        return lab
    }()
    
    private lazy var lineView: UIView = {
        let line = UIView()
        line.frame.size = CGSize(width: bounds.width, height: 1)
        line.frame.origin.y = bounds.height - 1
        line.backgroundColor = .gray
        return line
    }()
    
    open func didTouchUpInside(control: UIControl) {
        latestViewController?.navigationController?.popViewController(animated: true)
    }
}

extension BaseHeaderView {
    
    public var backControl: UIControl {
        myBackBtn
    }
    
    public var titleLabel: UILabel {
        myTitleLab
    }
}

extension BaseHeaderView {
    
    @objc private
    func touchUpInside(myBackBtn: UIControl) {
        didTouchUpInside(control: myBackBtn)
    }
}

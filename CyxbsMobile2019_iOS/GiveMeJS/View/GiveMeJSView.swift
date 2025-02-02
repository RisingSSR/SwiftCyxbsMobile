//
//  GiveMeJSView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/11/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class GiveMeJSView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GiveMeJSView {
    
    func createTitleStyleLab(title: String?) -> UILabel {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 18, weight: .semibold)
        lab.textColor = .ry(light: "#122D55", dark: "#F0F0F2")
        lab.text = title
        lab.sizeToFit()
        return lab
    }
    
    func createButton(title: String?) -> UIButton {
        let btn = UIButton()
        btn.frame.size = CGSize(width: 280, height: 52)
        btn.layer.cornerRadius = btn.bounds.height / 2
        btn.clipsToBounds = true
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        btn.backgroundColor = .ry(light: "#C2CBFE", dark: "#AFBAD6")
        btn.addTarget(self, action: #selector(touchUpInside(btn:)), for: .touchUpInside)
        return btn
    }
    
    func createTextField(placeholder: String?, leftSpace: CGFloat = 16) -> UITextField {
        let textField = UITextField(frame: CGRect(x: leftSpace, y: 0, width: bounds.width - 2 * leftSpace, height: 50))
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .ry(light: "#F2F3F7", dark: "#2D2D2D")
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        textField.leftViewMode = .always
        return textField
    }
}

extension GiveMeJSView {
    
    @objc
    func touchUpInside(btn: UIButton) {
        
    }
}

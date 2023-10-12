//
//  BaseTextFiledViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class BaseTextFiledViewController: UIViewController {
    
    typealias DismissAction = (_ shouldPresent: Bool, _ optionalVC: BaseTextFiledViewController?) -> ()
    
    var dismissAction: DismissAction?
    
    var heightForItem: CGFloat { 48 }
    var marginSpaceForHorizontal: CGFloat { 27 }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ry(light: "#F2F3F8", dark: "#000000")
        view.addSubview(contentView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    lazy var contentView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var addNotification: Void = {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }()
    
    static func afterCallAction(showVC shouldShow: Bool, action: @escaping DismissAction) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if shouldShow {
                
                let vc = LoginViewController()
                vc.dismissAction = action
                action(true, vc)
            } else {
                
                action(false, nil)
            }
        }
    }
}

// MARK: fact

extension BaseTextFiledViewController {
    
    func createLoginTypeTextFiled(placeholder: String, leftImgName: String) -> UITextField {
        let textField = UITextField(frame: CGRect(x: marginSpaceForHorizontal, y: 0, width: view.bounds.width - 2 * marginSpaceForHorizontal, height: heightForItem))
        textField.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        textField.backgroundColor = .clear
        textField.attributedPlaceholder =
        NSAttributedString(string: placeholder, attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.ry(light: "#8B8B8B", dark: "#C2C2C2")
        ])
        textField.textColor = .ry(light: "#242424", dark: "#E9E9E9")
        textField.font = .systemFont(ofSize: 16, weight: .bold)
        
        let leftBackView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.bounds.height))
        let leftImgView = UIImageView(frame: leftBackView.bounds)
        leftImgView.autoresizingMask = [.flexibleHeight]
        leftImgView.contentMode = .left
        leftImgView.image = UIImage(named: leftImgName)?.scaled(toWidth: 20)
        leftBackView.addSubview(leftImgView)
        textField.leftView = leftBackView
        textField.leftViewMode = .always
        
        let line = UIView(frame: CGRect(x: 0, y: heightForItem - 1, width: textField.bounds.width, height: 1))
        line.backgroundColor = .ry(light: "#E2EDFB", dark: "#7C7C7C")
        
        return textField
    }
    
    func createForgotTypeTextFiled(placeholder: String?, leftImgName: String?) -> UITextField {
        let textField = UITextField(frame: CGRect(x: marginSpaceForHorizontal, y: 0, width: view.bounds.width - 2 * marginSpaceForHorizontal, height: heightForItem))
        textField.layer.cornerRadius = 15
        textField.backgroundColor = .ry(light: "#F2F3F7", dark: "#2D2D2D")
        textField.font = .systemFont(ofSize: 18, weight: .semibold)
        textField.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        textField.placeholder = placeholder
        
        let leftBackView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: 0))
        textField.leftView = leftBackView
        textField.leftViewMode = .always
        if let leftImgName {
            view.frame.size.width = 40
            let leftImgView = UIImageView(frame: leftBackView.bounds)
            leftImgView.autoresizingMask = [.flexibleHeight]
            leftImgView.contentMode = .left
            leftImgView.image = UIImage(named: leftImgName)?.scaled(toWidth: 20)
            leftBackView.addSubview(leftImgView)
        }
        
        textField.delegate = self
        return textField
    }
    
    func createSureButton(size: CGSize,
                          title: String?,
                          touchUpInside: Selector) -> UIButton {
        let btn = UIButton()
        btn.frame.size = size
        btn.layer.cornerRadius = size.height / 2
        btn.clipsToBounds = true
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        btn.backgroundColor = .ry(light: "#ABBCD8", dark: "#AFBAD6")
        btn.addTarget(self, action: touchUpInside, for: .touchUpInside)
        return btn
    }
    
}

// MARK: interactive

extension BaseTextFiledViewController {
    
    @objc
    func keyboardWillShowNotification(_ notification: Notification) {
        if let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if let textField = UIResponder.firstResponder as? UITextField {
                let bottom = view.convert(info, to: view).minY
                if textField.frame.maxY + marginSpaceForHorizontal <= bottom {
                    UIView.animate(withDuration: 0.3) {
                        self.contentView.frame.origin.y = 0
                    }
                    return
                }
                UIView.animate(withDuration: 0.3) {
                    self.contentView.frame.origin.y -= (textField.frame.maxY - (bottom - self.marginSpaceForHorizontal))
                }
            }
        }
    }
    
    @objc
    func keyboardWillHideNotification(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.frame.origin.y = 0
        }
    }
}

// MARK: UITextFieldDelegate

extension BaseTextFiledViewController: UITextFieldDelegate {
    
}

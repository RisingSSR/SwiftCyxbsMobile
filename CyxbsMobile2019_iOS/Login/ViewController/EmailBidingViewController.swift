//
//  EmailBidingViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class EmailBidingViewController: BaseTextFiledViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.addSubview(bidingLab)
        contentView.addSubview(contentLab)
        contentView.addSubview(emailTextField)
        contentView.addSubview(codeTextField)
        
        updateFrame()
    }
    
    lazy var bidingLab: UILabel = {
        let lab = UILabel()
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        lab.text = "绑定你的邮箱"
        lab.textColor = UIColor.ry(light: "#15315B", dark: "#F0F0F0")
        lab.font = .systemFont(ofSize: 34, weight: .semibold)
        return lab
    }()
    
    lazy var contentLab: UILabel = {
        let lab = UILabel()
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        lab.text = "用于忘记密码时可以通过邮箱找回"
        lab.textColor = UIColor.ry(light: "#6C809B", dark: "#909090")
        lab.font = .systemFont(ofSize: 18, weight: .semibold)
        return lab
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = createForgotTypeTextFiled(placeholder: "请输入邮箱", leftImgName: nil)
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    lazy var codeTextField: UITextField = {
        let textField = createForgotTypeTextFiled(placeholder: "请输入邮箱验证码", leftImgName: nil)
        textField.keyboardType = .numberPad
        return textField
    }()
}

// MARK: request

extension EmailBidingViewController {
    
    struct BidingType {
        let question: Bool
        let email: Bool
    }
    
    static func isBiding(handle: @escaping (NetResponse<BidingType>) -> ()) {
        HttpManager.shared.user_secret_user_bind_is(stu_num: Constants.mainSno ?? "").ry_JSON { response in
            switch response {
            case .success(let model):
                let status = model["status"].intValue
                if status == 10000 {
                    let question_is = model["question_is"].intValue != 0
                    let email_is = model["email_is"].intValue != 0
                    let bidingType = BidingType(question: question_is, email: email_is)
                    handle(.success(bidingType))
                }
            case .failure(let netError):
                handle(.failure(netError))
            }
        }
    }
}

// MARK: update

extension EmailBidingViewController {
    
    func updateFrame() {
        bidingLab.sizeToFit()
        bidingLab.frame.origin = CGPoint(x: 15, y: 80 + Constants.statusBarHeight)
        
        contentLab.sizeToFit()
        contentLab.frame.origin = CGPoint(x: bidingLab.frame.minX, y: bidingLab.frame.maxY + 8)
        
        emailTextField.frame.origin.y = contentLab.frame.maxY + 32
        
        codeTextField.frame.origin.y = emailTextField.frame.maxY + 32
    }
}

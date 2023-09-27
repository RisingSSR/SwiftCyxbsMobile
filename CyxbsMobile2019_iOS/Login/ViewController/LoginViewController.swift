//
//  LoginViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import ProgressHUD

class LoginViewController: BaseTextFiledViewController {
    
    typealias DismissAction = (_ shouldPresent: Bool, _ optionalVC: LoginViewController?) -> ()
    
    static let agreementURL = Bundle.main.url(forResource: "掌上重邮用户协议", withExtension: "md")!
    
    var dismissAction: DismissAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addSubview(loginLab)
        contentView.addSubview(welcomeLab)
        contentView.addSubview(snoTextField)
        contentView.addSubview(pwdTextField)
        contentView.addSubview(tipLab)
        contentView.addSubview(sureBtn)
        contentView.addSubview(agreementView)
        
        updateFrame()
        showAgreementIfNeeded()
    }
    
    // MARK: lazy
    
    lazy var loginLab: UILabel = {
        let lab = UILabel()
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        lab.text = "登录"
        lab.textColor = UIColor.ry(light: "#15315B", dark: "#F0F0F0")
        lab.font = .systemFont(ofSize: 34, weight: .semibold)
        return lab
    }()
    
    lazy var welcomeLab: UILabel = {
        let lab = UILabel()
        lab.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        lab.text = "你好，欢迎来到掌上重邮！"
        lab.textColor = UIColor.ry(light: "#6C809B", dark: "#909090")
        lab.font = .systemFont(ofSize: 18, weight: .semibold)
        return lab
    }()
    
    lazy var snoTextField: UITextField = {
        let textField = createLoginTypeTextFiled(placeholder: "请输入学号", leftImgName: "login_sno_large")
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    lazy var pwdTextField: UITextField = {
        let textField = createLoginTypeTextFiled(placeholder: "身份证/统一认证码后6位", leftImgName: "login_authentication")
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    lazy var tipLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .ry(light: "#8B8B8B", dark: "#C2C2C2")
        lab.font = .systemFont(ofSize: 11, weight: .medium)
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.text = "2020级及以后学生默认密码为统一认证码后六位，其余同学默认密码为身份证后六位。"
        return lab
    }()
    
    lazy var sureBtn: UIButton = {
        let btn = createSureButton(size: CGSize(width: 280, height: 52), title: "登 录", touchUpInside: #selector(clickSureBtn(btn:)))
        btn.isEnabled = false
        return btn
    }()
    
    lazy var agreementView: BaseAgreementView = {
        let agreementView = BaseAgreementView()
        let url = LoginViewController.agreementURL
        agreementView.set(leadingText: "请阅读并同意", agreementText: "《掌上重邮用户协议》", agreemntURL: url)
        let selectedImg = UIImage(named: "check")?
            .tint(.white, blendMode: .destinationIn)
            .tint(.hex("#4841E2"), blendMode: .destinationOut)
        agreementView.set(normalImg: nil, selectedImg: selectedImg)
        agreementView.updateFrame()
        agreementView.checkBtn.layer.cornerRadius = agreementView.checkBtn.bounds.height / 2
        agreementView.checkBtn.layer.borderWidth = 1
        agreementView.checkBtn.layer.borderColor = UIColor.gray.cgColor
        agreementView.checkBtn.clipsToBounds = true
        agreementView.delegate = self
        return agreementView
    }()
}

// MARK: update

extension LoginViewController {
    
    func updateFrame() {
        loginLab.sizeToFit()
        loginLab.frame.origin = CGPoint(x: 15, y: 80 + Constants.statusBarHeight)
        
        welcomeLab.sizeToFit()
        welcomeLab.frame.origin = CGPoint(x: loginLab.frame.minX, y: loginLab.frame.maxY + 8)
        
        snoTextField.frame.origin.y = welcomeLab.frame.maxY + 32
        
        pwdTextField.frame.origin.y = snoTextField.frame.maxY + 32
        
        tipLab.frame.size.width = pwdTextField.bounds.width
        tipLab.sizeToFit()
        tipLab.frame.origin = CGPoint(x: pwdTextField.frame.minX, y: pwdTextField.frame.maxY + 14)
        
        sureBtn.frame.origin.y = tipLab.frame.maxY + 72
        sureBtn.center.x = view.bounds.width / 2
        
        agreementView.frame.origin.y = view.bounds.height - agreementView.bounds.height - 53
        agreementView.center.x = view.bounds.width / 2
    }
}

// MARK: interactive

extension LoginViewController {
    
    @objc
    func clickSureBtn(btn: UIButton) {
        loginIfNeeded()
    }
    
    func loginIfNeeded() {
        guard let snoText = snoTextField.text, snoText.count > 2,
        let pwdText = pwdTextField.text, pwdText.count > 0
        else {
            ProgressHUD.show("需要同时填写账号/密码", icon: .failed, delay: 0.8)
            return
        }
        
        ProgressHUD.show("正在登录...")
        HttpManager.shared.magipoke_token(stuNum: snoText, idNum: pwdText).ry_JSON { response in
            switch response {
            case .success(let model):
                if let status = model["status"].string {
                    if status == "10000" {
                        Constants.mainSno = snoText
                        Constants.token = model["data"]["token"].string
                        UserDefaultsManager.shared.refreshToken = model["data"]["refreshToken"].string
                        ProgressHUD.showSucceed("登录成功")
                        self.dismiss(animated: true) {
                            self.dismissAction?(false, self)
                        }
                    } else if status == "20004" {
                        ProgressHUD.showError("账号或密码出错")
                    }
                }
                
            case .failure(let netError):
                print("netError\(netError)")
                ProgressHUD.show("网络异常")
            }
        }
    }
    
    func showAgreementIfNeeded() {
        guard let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showAgreement()
            }
            return
        }
    }
    
    func showAgreement(url: URL? = nil) {
        let vc = MarkDownViewController()
        vc.delegate = self
        vc.url = url ?? LoginViewController.agreementURL
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: BaseAgreementViewDelegate

extension LoginViewController: BaseAgreementViewDelegate {
    
    func agreementView(_ agreementView: BaseAgreementView, interactWith URL: URL) {
        showAgreement(url: URL)
    }
    
    func agreementView(_ agreementView: BaseAgreementView, touchedUpInsideCheckButton btn: UIButton) {
        guard let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead else {
            self.showAgreement()
            return
        }
        
        btn.isSelected.toggle()
        if btn.isSelected {
            sureBtn.isEnabled = true
            sureBtn.backgroundColor = .hex("#4A45DC")
        } else {
            sureBtn.isEnabled = false
            sureBtn.backgroundColor = .ry(light: "#ABBCD8", dark: "#AFBAD6")
        }
    }
}

// MARK: MarkDownViewControllerDelegate

extension LoginViewController: MarkDownViewControllerDelegate {
    
    func mdViewControllerDidCancel(_ controller: MarkDownViewController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = false
    }
    
    func mdViewControllerDidDown(_ controller: MarkDownViewController) {
        controller.dismiss(animated: true)
        UserDefaultsManager.shared.didReadUserAgreementBefore = true
        if !agreementView.didCheckBtn {
            agreementView.toggleCheckBtn()
        }
    }
}

// MARK: static

extension LoginViewController {
    
    static func check(action: @escaping DismissAction) {
        
        // 没有token，需要show
        guard Constants.mainSno != nil,
        let refreshToken = UserDefaultsManager.shared.refreshToken,
              
        // 新版本，需要show; 没读用户协议，需要show
        let didRead = UserDefaultsManager.shared.didReadUserAgreementBefore, didRead,
              
        // 上一次未打开App，需要show
        let lastDate = UserDefaultsManager.shared.latestOpenApp else {
            
            afterCallAction(true)
            return
        }
        
        // 不是一天，请求新的token
        if !Calendar.current.isDateInToday(lastDate) {
            requestNewToken(refreshToken: refreshToken) { isSuccess in
                afterCallAction(!isSuccess)
                return
            }
        }
        
        func afterCallAction(_ shouldShow: Bool) {
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
    
    static func requestNewToken(refreshToken: String, success: @escaping (Bool) -> ()) {
        HttpManager.shared.magipoke_token_refresh(refreshToken: refreshToken).ry_JSON { response in
            switch response {
            case .success(let model):
                Constants.token = model["data"]["token"].string
                UserDefaultsManager.shared.refreshToken = model["data"]["refreshToken"].string
                success(true)
                return
                
            case .failure(_):
                success(false)
                return
            }
        }
    }
}

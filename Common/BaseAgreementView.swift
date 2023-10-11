//
//  BaseAgreementView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

// MARK: BaseAgreementViewDelegate

protocol BaseAgreementViewDelegate: AnyObject {
    
    func agreementView(_ agreementView: BaseAgreementView, interactWith URL: URL)
    
    func agreementView(_ agreementView: BaseAgreementView, touchedUpInsideCheckButton btn: UIButton)
}

// MARK: BaseAgreementView

class BaseAgreementView: UIView {
    
    weak var delegate: BaseAgreementViewDelegate?
    
    var didCheckBtn: Bool { checkBtn.isSelected }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(checkBtn)
        addSubview(textView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var checkBtn: UIButton = {
        let btn = UIButton()
        btn.imageEdgeInsets = .zero
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(touchUpInside(checkBtn:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.delegate = self
        textView.dataDetectorTypes = .link
        textView.isEditable = false
        textView.isSelectable = true
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
}

// MARK: interactive

extension BaseAgreementView {
    
    @objc
    func touchUpInside(checkBtn btn: UIButton) {
        delegate?.agreementView(self, touchedUpInsideCheckButton: btn)
    }
}

// MARK: method

extension BaseAgreementView {
    
    func toggleCheckBtn() {
        touchUpInside(checkBtn: checkBtn)
    }
    
    func set(normalImg: UIImage?, selectedImg: UIImage?) {
        checkBtn.setImage(normalImg, for: .normal)
        checkBtn.setImage(selectedImg, for: .selected)
    }
    
    func set(leadingText: String, agreementText: String, agreemntURL: URL, speacialFont: UIFont = .systemFont(ofSize: 11)) {
        let leading = NSAttributedString(string: leadingText, attributes: [
            .font: speacialFont,
            .foregroundColor: UIColor.ry(light: "#ABBCD8", dark: "#AFBAD6")
        ])
        let agreement = NSAttributedString(string: agreementText, attributes: [
            .font: speacialFont,
            .foregroundColor: UIColor.hex("#4841E2"),
            .link: agreemntURL
        ])
        let attribute = NSMutableAttributedString(attributedString: leading)
        attribute.append(agreement)
        textView.attributedText = attribute
    }
    
    func updateFrame() {
        textView.sizeToFit()
        let height = textView.bounds.height - 2 * 8
        checkBtn.frame.size = CGSize(width: height, height: height)
        checkBtn.center.y = textView.center.y
        textView.frame.origin.x = checkBtn.frame.maxX + 8
        
        frame.size = CGSize(width: textView.frame.maxX, height: textView.bounds.height)
    }
}

// MARK: UITextViewDelegate

extension BaseAgreementView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        delegate?.agreementView(self, interactWith: URL)
        return false
    }
}

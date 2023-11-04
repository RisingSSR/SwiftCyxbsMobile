//
//  GiveMeJSHeaderView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/11/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class GiveMeJSHeaderView: BaseHeaderView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(deleteBtn)
        setupData()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("删除", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.setTitleColor(.ry(light: "#112C54", dark: "#F0F0F2"), for: .normal)
        btn.sizeToFit()
        return btn
    }()
}

// MARK: setup

extension GiveMeJSHeaderView {
    
    func setupData() {
        titleLabel.text = "掌邮JS任务"
        titleLabel.sizeToFit()
    }
    
    func setupUI() {
        titleLabel.frame.origin.y = Constants.statusBarHeight + 2
        titleLabel.center.x = bounds.width / 2
        deleteBtn.frame.origin.x = bounds.width - deleteBtn.bounds.width - 10
        deleteBtn.frame.origin.y = titleLabel.frame.minY
    }
}

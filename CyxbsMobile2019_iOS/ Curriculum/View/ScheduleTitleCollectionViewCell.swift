//
//  ScheduleTitleCollectionViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleTitleCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String? {
        set {
            titleLab.text = newValue
            titleLab.sizeToFit()
        }
        get { titleLab.text }
    }
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 22, weight: .bold)
        lab.textColor = .ry.color(light: .hex("#112C54"), dark: .hex("#F0F0F2"))
        return lab
    }()
}

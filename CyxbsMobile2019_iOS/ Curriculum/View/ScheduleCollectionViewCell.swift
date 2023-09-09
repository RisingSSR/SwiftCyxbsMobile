//
//  ScheduleCollectionViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    // MARK: ReuseIdentifier
    
    static let curriculumReuseIdentifier = "CyxbsMobile2019_iOS.ScheduleCollectionViewCell.curriculum"
    static let supplementaryReuseIdentifier = "CyxbsMobile2019_iOS.ScheduleCollectionViewCell.supplementary"
    
    // MARK: DrawType
    
    enum DrawType {
        
        enum CurriculumType {
            
            case morning
            
            case afternoon
            
            case night
            
            case others
            
            case custom
        }
        
        enum SupplementaryType {
            
            case normal
            
            case select
        }
        
        case curriculum(CurriculumType)
        
        case supplementary(SupplementaryType)
    }
    
    // MARK: init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        print(reuseIdentifier)
        if reuseIdentifier == ScheduleCollectionViewCell.curriculumReuseIdentifier {
            initCurriculum()
        } else if reuseIdentifier == ScheduleCollectionViewCell.supplementaryReuseIdentifier {
            initSupplementary()
        }
        contentView.addSubview(titleLab)
        contentView.addSubview(contentLab)
        updateFrame()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var drawType: DrawType = .curriculum(.morning)
    
    private(set) var isTitleOnly: Bool = false
    
    private(set) var isMultiple: Bool = false
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        updateFrame()
    }
    
    // MARK: lazy
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .clear
        lab.textAlignment = .center
        lab.numberOfLines = 3
        return lab
    }()
    
    lazy var contentLab: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .clear
        lab.textAlignment = .center
        lab.numberOfLines = 3
        return lab
    }()
    
    lazy var backImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.image = UIImage(named: "curriculum.custom_course")
        imgView.contentMode = .scaleAspectFill
        imgView.isHidden = true
        return imgView
    }()
    
    lazy var multyView: UIView = {
        let multyView = UIView(frame: CGRect(x: .zero, y: 4, width: 8, height: 2))
        multyView.frame.origin.x = contentView.bounds.width - multyView.bounds.width - 5
        multyView.autoresizingMask = [.flexibleLeftMargin]
        multyView.layer.cornerRadius = multyView.bounds.height / 2
        multyView.clipsToBounds = true
        multyView.isHidden = true
        return multyView
    }()
}

// MARK: - init

extension ScheduleCollectionViewCell {
    
    func initCurriculum() {
        drawType = .curriculum(.morning)
        titleLab.font = .systemFont(ofSize: 10, weight: .regular)
        contentLab.font = .systemFont(ofSize: 10, weight: .regular)
        contentView.addSubview(backImgView)
        contentView.addSubview(multyView)
    }
    
    func initSupplementary() {
        drawType = .supplementary(.normal)
        titleLab.font = .systemFont(ofSize: 12, weight: .regular)
        contentLab.font = .systemFont(ofSize: 11, weight: .regular)
    }
}

// MARK: Method

extension ScheduleCollectionViewCell {
    
    func set(curriculumType: DrawType.CurriculumType, title: String?, content: String?, isMultiple: Bool) {
        drawType = .curriculum(curriculumType)
        isTitleOnly = false
        titleLab.text = title
        contentLab.text = content
        backImgView.isHidden = (curriculumType != .custom)
        updateFrame()
    }
    
    func set(supplementaryType: DrawType.SupplementaryType, title: String?, content: String?, isTitleOnly: Bool) {
        drawType = .supplementary(supplementaryType)
        self.isTitleOnly = isTitleOnly
        titleLab.text = title
        contentLab.text = content
        updateFrame()
    }
    
    func updateFrame() {
        switch drawType {
        case .curriculum(_):
            let space: CGFloat = 8
            titleLab.frame.origin = CGPoint(x: space, y: space)
            titleLab.frame.size.width = bounds.width - 2 * space
            titleLab.sizeToFit()
            titleLab.center.x = bounds.width / 2
            
            contentLab.frame.size.width = bounds.width - 2 * space
            contentLab.frame.origin.y = bounds.height - contentLab.bounds.height - space
            contentLab.sizeToFit()
            contentLab.center.x = bounds.width / 2
            
        case .supplementary(_):
            titleLab.sizeToFit()
            titleLab.frame.origin.x = 0
            titleLab.frame.size.width = bounds.width
            
            contentLab.sizeToFit()
            contentLab.frame.origin.x = 0
            contentLab.frame.size.width = bounds.width
            
            if isTitleOnly {
                titleLab.center.y = bounds.height / 2
                contentLab.isHidden = true
            } else {
                titleLab.frame.origin.y = 6
                contentLab.isHidden = false
            }
            contentLab.frame.origin.y = bounds.height - contentLab.bounds.height - 3
        }
    }
}

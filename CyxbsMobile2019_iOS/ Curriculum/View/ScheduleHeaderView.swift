//
//  ScheduleHeaderView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/18.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionLab)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var sectionLab: UILabel = {
        let lab = UILabel()
        lab.frame.origin = CGPoint(x: 16, y: 16)
        return lab
    }()
}

extension ScheduleHeaderView {
    
    func updateData(section: Int, isNowSection: Bool) {
        var title = "整学期"
        if section >= 1 {
            let formatter = NumberFormatter()
            formatter.locale = .cn
            formatter.numberStyle = .spellOut
            if let num = formatter.string(from: section as NSNumber) {
                title = "第" + num + "周"
            }
        }
        let content = isNowSection ? "（本周）" : nil
        let sectionShow = create(title: title, content: content)
        UIView.transition(with: sectionLab, duration: 0.5, options: [.transitionCrossDissolve]) {
            self.sectionLab.attributedText = sectionShow
            self.sectionLab.sizeToFit()
        }
    }
    
    func create(title: String, content: String?) -> NSAttributedString {
        let titleStr = NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .foregroundColor: UIColor.ry.titleColorForPlace_main
        ])
        let fullStr = NSMutableAttributedString(attributedString: titleStr)
        if let content {
            let contentStr = NSAttributedString(string: content, attributes: [
                .font: UIFont.systemFont(ofSize: 15, weight: .regular),
                .foregroundColor: UIColor.ry.titleColorForPlace_main
            ])
            fullStr.append(contentStr)
        } else {
            fullStr.append(NSAttributedString(string: " "))
        }
        let to = NSAttributedString(string: ">", attributes: [
            .font: UIFont.systemFont(ofSize: 15, weight: .regular),
            .foregroundColor: UIColor.ry.titleColorForPlace_main
        ])
        fullStr.append(to)
        return fullStr
    }
}

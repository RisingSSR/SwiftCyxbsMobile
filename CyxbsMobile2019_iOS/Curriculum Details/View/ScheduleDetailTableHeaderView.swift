//
//  ScheduleDetailTableHeaderView.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/20.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol ScheduleDetailTableHeaderViewDelegate: AnyObject {
    
    func tableHeaderView(_ tableHeaderView: ScheduleDetailTableHeaderView, responsePlaceTap tap: UITapGestureRecognizer)
    
    func tableHeaderView(_ tableHeaderView: ScheduleDetailTableHeaderView, touchUpInsideEditButton btn: UIButton)
}

class ScheduleDetailTableHeaderView: UIView {
    
    private let space: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(editBtn)
        addSubview(snoLab)
        addSubview(courseLab)
        addSubview(placeLab)
        addSubview(teacherLab)
        addSubview(toImgView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    weak var delegate: ScheduleDetailTableHeaderViewDelegate? = nil
    
    func setupUI() {
        toImgView.contentMode = .center
        placeLab.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(placeResponse(tap:)))
        placeLab.addGestureRecognizer(tap)
    }
    
    // MARK: lazy
   
    lazy var courseLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 22, weight: .semibold)
        lab.textColor = .ry(light: "#112C54", dark: "#F0F0F2")
        return lab
    }()
    
    lazy var snoLab = createContentLab()
    
    lazy var placeLab = createContentLab()
    
    lazy var teacherLab = createContentLab()
    
    lazy var toImgView = 
    UIImageView(image: UIImage(named: "direction_right")?
        .tint(.ry(light: "#112C54", dark: "#F0F0F2"), blendMode: .destinationIn)
        .scaled(toHeight: 10))
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(gradientLayerSize: CGSize(width: 50, height: 28), title: "编辑")
        btn.autoresizingMask = [.flexibleLeftMargin]
        btn.addTarget(self, action: #selector(editTouchUpInside(btn:)), for: .touchUpInside)
        return btn
    }()
    
    func createContentLab() -> UILabel {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 13, weight: .regular)
        lab.textColor = .ry(light: "#112C54", dark: "#F0F0F2")
        return lab
    }
}

// MARK: response

extension ScheduleDetailTableHeaderView {
    
    @objc
    func editTouchUpInside(btn: UIButton) {
        
    }
    
    
    @objc
    func placeResponse(tap: UITapGestureRecognizer) {
        
    }
}



// MARK: updateData

extension ScheduleDetailTableHeaderView {
    
    func set(course: String?, sno: String?, place: String?, teacher: String?) {
        courseLab.text = course
        snoLab.text = sno
        placeLab.text = place
        teacherLab.text = teacher
        updateFrame()
    }
    
    var isEditBtnShow: Bool {
        set { editBtn.isHidden = !newValue }
        get { !editBtn.isHidden }
    }
    
    func updateFrame() {
        /*
         [courseLab] <Space> [editBtn]
         [snoLab]
         [placeLab] [toImgView] [teacherLab]
         */
        
        editBtn.frame.origin = CGPoint(x: bounds.width - editBtn.bounds.width - space, y: space)
        
        courseLab.frame.origin.x = space
        courseLab.sizeToFit()
        courseLab.center.y = editBtn.center.y
        if courseLab.frame.maxX >= editBtn.frame.minX - space {
            courseLab.frame.size.width = editBtn.frame.minX - courseLab.frame.minX - space
        }
        
        snoLab.frame.origin = CGPoint(x: space, y: courseLab.frame.maxY + 6)
        snoLab.sizeToFit()
        
        teacherLab.sizeToFit()
        
        placeLab.frame.origin = CGPoint(x: space, y: snoLab.frame.maxY + 6)
        placeLab.frame.size.width = bounds.width - teacherLab.bounds.width - 3 * space - 4
        placeLab.sizeToFit()
        
        toImgView.frame.origin = CGPoint(x: placeLab.frame.maxX + 4, y: placeLab.frame.minY + 3)
        
        teacherLab.frame.origin = CGPoint(x: toImgView.frame.maxX + space, y: placeLab.frame.minY)
    }
}

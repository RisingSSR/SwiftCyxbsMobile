//
//  FinderElectricChargeView.swift
//  CyxbsMobile2019_iOS
//
//  Created by Whitiy on 2023/10/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import SwiftyJSON

class FinderElectricChargeView: UIView{
   
     let viewModel: FinderElectricChargeViewModel
    private let disposeBag = DisposeBag()
    
    

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let pickerViewController = DormitoryPickerViewController()
        pickerViewController.viewModel = viewModel
        
        pickerViewController.modalPresentationStyle = .overFullScreen

        
        if let viewController = self.window?.rootViewController {
            viewController.present(pickerViewController, animated: true, completion: nil)
        }
    }
    

    
    override init(frame: CGRect) {

        viewModel = FinderElectricChargeViewModel()
        super.init(frame: frame)
   
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        self.addGestureRecognizer(tapGesture)
        

        viewModel.this_month_charge.bind(to: dueAmountLabel.rx.text).disposed(by: disposeBag)
        viewModel.this_month_used.bind(to: usageLabel.rx.text).disposed(by: disposeBag)
        viewModel.update_time.bind(to: meterReadingTimeLabel.rx.text).disposed(by: disposeBag)
      
        
        [meterReadingTimeLabel,dueAmountLabel,usageLabel,titleLab,dueAmountSubLabel,usageSubLabel,dueAmountDesLabel,usageDesLabel].forEach{ label in
            //label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
        }

        
        //snapkit
        titleLab.snp.makeConstraints{
            (make) in
            make.top.left.equalTo(self).offset(10)
        }
        
        meterReadingTimeLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        
        dueAmountLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.left.equalTo(self).offset(50)
        }
        
        dueAmountSubLabel.snp.makeConstraints{
            (make) in
            make.left.equalTo(dueAmountLabel.snp.right).offset(5)
            make.bottom.equalTo(dueAmountLabel.snp.bottom).offset(-5)
        }
        
        dueAmountDesLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(dueAmountLabel.snp.bottom).offset(10)
           // make.centerXWithinMargins.equalTo(dueAmountLabel)
           // make.centerX.equalTo(dueAmountLabel.snp.right)
            make.centerX.equalTo(dueAmountSubLabel.snp.left).offset(-10)
//            make.centerX.equalTo(dueAmountLabel.snp.left).offset((dueAmountSubLabel.snp.right - dueAmountLabel.snp.left)/2)
           
            
        }
        
        usageLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(20)
            make.right.equalTo(usageSubLabel.snp.left).offset(-5)
        }
        
        usageSubLabel.snp.makeConstraints{
            (make) in
            make.left.equalTo(usageLabel.snp.right)
            make.bottom.equalTo(usageLabel.snp.bottom).offset(-5)
            make.right.equalTo(self).offset(-50)
        }
        
        usageDesLabel.snp.makeConstraints{
            (make) in
            make.top.equalTo(usageLabel.snp.bottom).offset(10)
            make.centerX.equalTo(usageSubLabel.snp.left).offset(-15)
        }
        
        
        
    }
    
  
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let meterReadingTimeLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 8, weight: .semibold)
        //lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.textColor = .gray
        lab.text = "抄表时间"
        lab.sizeToFit()
        return lab
    }()
        let dueAmountLabel: UILabel = {
            let lab = UILabel()
            lab.font = .systemFont(ofSize: 26, weight: .bold)
            lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
            lab.text = "100.00"
            lab.sizeToFit()
            return lab
        }()
    
    let dueAmountSubLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 10, weight: .semibold)
        lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.text = "元"
        lab.sizeToFit()
        return lab
    }()
    let dueAmountDesLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 10, weight: .semibold)
        //lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.textColor = .gray
        lab.text = "应缴/本月"
        lab.sizeToFit()
        return lab
    }()
        let usageLabel: UILabel = {
            let lab = UILabel()
            lab.font = .systemFont(ofSize: 26, weight: .bold)
            lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
            lab.text = "100"
            lab.sizeToFit()
            return lab
        }()
    
    let usageSubLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 10, weight: .semibold)
        lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.text = "度"
        lab.sizeToFit()
        return lab
    }()
    
    let usageDesLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 10, weight: .semibold)
        //lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.textColor = .gray
        lab.text = "使用度数/本月"
        lab.sizeToFit()
        return lab
    }()
    
    lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14, weight: .bold)
        lab.textColor = .ry(light: "#15315B", dark: "#F0F0F2")
        lab.text = "电费查询"
        lab.sizeToFit()
        return lab
    }()
    
}



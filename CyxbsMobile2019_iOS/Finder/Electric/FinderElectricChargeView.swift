//
//  FinderElectricChargeView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 白鑫 on 2023/10/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import SwiftyJSON

class FinderElectricChargeView: UIView{
   
    var viewModel: FinderElectricChargeViewModel!
    private let disposeBag = DisposeBag()
    
    lazy var dormitories: [Dormitory] = {
        CacheManager.shared.getCodable([Dormitory].self, in: .dormitoryFromBundle)
        ?? []
    }()
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
  
        
        let alert = UIAlertController(title: "寝室选择测试", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
      //  self.dormitories = jsonData
        if let viewController = self.window?.rootViewController {
            print("获取了vc")
            viewController.present(alert, animated: true, completion: nil)
        }else{
            print("无法获取vc")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
        
        
        viewModel = FinderElectricChargeViewModel()
        
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


extension FinderElectricChargeView: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dormitories.count
        } else {
            return dormitories[component].buildings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return dormitories[row].name
        } else {
            return dormitories[component].buildings[row].name
        }
    }
}

extension FinderElectricChargeView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedBuildingId = self.dormitories.flatMap { $0.buildings }[row].building_id
        
        // self.viewModel.buildingId = selectedBuildingId
    }
}

//
//  DormitoryPickerView.swift
//  CyxbsMobile2019_iOS
//
//  Created by WHITIY on 2023/11/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import UIKit

class DormitoryPickerViewController: UIViewController{
    
    var baseVC: UIViewController? = nil
    var selectedDormitory: Dormitory? = nil
    
    lazy var dormitories: [Dormitory] = {
        
        var value = CacheManager.shared.getCodable([Dormitory].self, in: .dormitoryFromBundle)
         ?? []
        
         print("数量：\(value.count)")
         return value
    }()
    
   lazy var pickerFrame: UIPickerView = {
       var pick = UIPickerView(frame: CGRect(x: 0, y: 60, width: 250, height: 120))
       return pick
   }(
    )
        lazy var roomIdLab: UILabel = {
            var label =  UILabel(frame: CGRect(x: 15, y: 35, width: 100, height: 30))
            label.text = "选择楼栋"
            label.font = .systemFont(ofSize: 10)
            label.textColor = .gray
            return label
        }()
    
    let roomLab: UILabel = {
        var roomLab = UILabel(frame: CGRect(x: 15, y: 5, width: 70, height: 50))
        roomLab.text = "宿舍号："
        return roomLab
    }()
        
    lazy var  backgroundButton = UIButton(frame: self.view.frame)
    
      
   lazy var roomInputor: UITextField = {
        var inp = UITextField(frame: CGRect(x: 80, y: 0, width: 100, height: 60))
        return inp
    }()
    

    
    var viewModel: FinderElectricChargeViewModel!
    lazy  var saveButton: UIButton = {
       var saveButton = UIButton(frame: CGRect(x: 80, y: 190, width: 100, height: 35))
        saveButton.backgroundColor = .blue
        saveButton.layer.cornerRadius = 18
                saveButton.setTitle("确定", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
                saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return saveButton
    }()
    @objc func dismissAlert() {
        print("关闭浮窗")
        self.dismiss(animated: true, completion: nil)
        //backgroundButton.removeFromSuperview()
    }
    
    @objc func saveButtonTapped() {
          let selectedDormitoryIndex = pickerFrame.selectedRow(inComponent: 0)
          let selectedBuildingIndex = pickerFrame.selectedRow(inComponent: 1)
          let selectedBuildingId = dormitories[selectedDormitoryIndex].buildings[selectedBuildingIndex].building_id
        //  viewModel.getInfo(building_id: selectedBuildingId)
        if (roomInputor.text?.isEmpty == true){
            print("没有指定寝室")
            BaseToast.showToast(message: "您需要指定一个寝室", viewController:self.view.window!.rootViewController!)
            return
        }else{
            print("按钮已选择：\(selectedBuildingId),房间：\(roomInputor.text ?? "没有选择")")
            viewModel.fetchData(buildingID: "\(selectedBuildingId)", room: "\(roomInputor.text!)")
            self.dismiss(animated: true, completion: nil)
        }
        
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        let centerView = UIView(frame: CGRect(x: 0, y: 0, width: 260, height: 240))
        centerView.center = self.view.center
        centerView.backgroundColor = .white
        centerView.layer.cornerRadius = 10
        
        backgroundButton.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        
        self.view.addSubview(backgroundButton)
        

        
        self.view.addSubview(centerView)
               centerView.addSubview(pickerFrame)
               centerView.addSubview(roomLab)
               centerView.addSubview(roomIdLab)
               centerView.addSubview(roomInputor)
               centerView.addSubview(saveButton)

                
                pickerFrame.dataSource = self
                pickerFrame.delegate = self
    }
}

extension DormitoryPickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return dormitories.count
        } else {
            let selectedDormitoryIndex = pickerView.selectedRow(inComponent: 0)
            return dormitories[selectedDormitoryIndex].buildings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return dormitories[row].name
        } else {
            let selectedDormitoryIndex = pickerView.selectedRow(inComponent: 0)
            return dormitories[selectedDormitoryIndex].buildings[row].name
        }
    }
}

extension DormitoryPickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            
            pickerView.reloadComponent(1)
        } else {
            let selectedDormitoryIndex = pickerView.selectedRow(inComponent: 0)
            let selectedBuildingId = dormitories[selectedDormitoryIndex].buildings[row].building_id
            // self.viewModel.buildingId = selectedBuildingId
            print("已选择：\(selectedBuildingId)")
            roomIdLab.text = "\(selectedBuildingId)栋"
            
        }
    }
}


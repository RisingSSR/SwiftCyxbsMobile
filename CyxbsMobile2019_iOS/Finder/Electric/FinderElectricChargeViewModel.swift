//
//  FinderElectricChargeViewModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 白鑫 on 2023/10/31.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FinderElectricChargeViewModel{

    let  buildingID = BehaviorRelay<String>(value: "")
    let room = BehaviorRelay<String>(value: "")
    
    let this_month_charge = BehaviorRelay<String>(value: "0.00")
    let this_month_used = BehaviorRelay<String>(value: "0")
    let update_time = BehaviorRelay<String>(value: "...")
    
   
    
    
    
    
    private let disposeBag = DisposeBag()
    
    
    
    

    
    func fetchData(buildingID:String, room: String){

        HttpManager.shared.magipoke_elecquery_getElectric(building: buildingID, room: room).ry_JSON { response in
            if case .success(let model) = response {
                
                if let status = model["status"].int, status == 200 {
                    let hasMessage = model["elec_inf"]
                    let dataModel = FinderElectricChargeModel(json: hasMessage)
                    

                    self.this_month_charge.accept(String(dataModel.elecFree))
                    self.this_month_used.accept(String(dataModel.elecSpend))
                    self.update_time.accept("\(String(dataModel.recordTime))抄表")
                    
                    
                   
                    
                    
                }else{
                   //其他状态码
                    
                }
            }
            
            
        }
    }
}

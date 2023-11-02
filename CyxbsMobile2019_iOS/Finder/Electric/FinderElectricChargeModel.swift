//
//  FinderElectricChargeModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 白鑫 on 2023/11/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FinderElectricChargeModel: Codable {
    let building, room: String
    let elecStart, elecEnd, elecFree, elecSpend: Int
    let elecCost: [String]
    let recordTime: String
    let lastmoney: Double

    enum CodingKeys: String, CodingKey {
        case building, room
        case elecStart = "elec_start"
        case elecEnd = "elec_end"
        case elecFree = "elec_free"
        case elecSpend = "elec_spend"
        case elecCost = "elec_cost"
        case recordTime = "record_time"
        case lastmoney
    }
}

extension FinderElectricChargeModel{
    init(json: JSON) {
        building = json["building"].stringValue
        room = json["room"].stringValue
        elecStart = json["elec_start"].intValue
        elecEnd = json["elec_end"].intValue
        elecFree = json["elec_free"].intValue
        elecSpend = json["elec_spend"].intValue
        elecCost = json["elec_cost"].arrayValue.map{ $0.stringValue}
        recordTime = json["record_time"].stringValue
        lastmoney = json["lastmoney"].doubleValue
        
        
    }
}

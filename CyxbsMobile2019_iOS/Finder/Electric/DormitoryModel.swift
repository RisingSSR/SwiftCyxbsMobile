//
//  DormitoryModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by Whitiy on 2023/11/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Dormitory: Codable {
    
    struct Building: Codable {
        
        let name: String
        
        let building_id: String
        
    
        init(json: JSON)  {
            name = json["name"].stringValue
            building_id = json["building_id"].stringValue
        }
    }
    
    
    
    let name: String
    
    let buildings: [Building]
}

extension Dormitory{
    init(json: JSON)  {
        name = json["name"].stringValue
        buildings = json["buildings"].arrayValue.map { Building(json: $0) }
    }
}


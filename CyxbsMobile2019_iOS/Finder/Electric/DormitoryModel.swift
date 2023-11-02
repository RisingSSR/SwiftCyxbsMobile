//
//  DormitoryModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 白鑫 on 2023/11/2.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct Dormitory: Codable {
    
    struct Building: Codable {
        
        let name: String
        
        let building_id: String
    }
    
    let name: String
    
    let buildings: [Building]
}

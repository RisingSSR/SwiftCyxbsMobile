//
//  QuickFeaturesModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct QuickFeaturesModel: Codable {
    
    var name: String
    
    var url: String
}

extension QuickFeaturesModel {
    
    init(json: JSON) {
        name = json["name"].stringValue
        url = json["url"].stringValue
    }
}

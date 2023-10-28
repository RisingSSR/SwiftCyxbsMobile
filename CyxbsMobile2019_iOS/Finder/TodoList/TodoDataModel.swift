//
//  TodoDataModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension TodoDataModel {
    
    /// 重复情况
    enum RepeatMode: Codable {
        
        case none
        
        case day
        
        case week
        
        case month
        
        case year
    }
    
    /// 完成情况
    enum State {
        
        case done
        
        case overdue
        
        case needDone
    }
}

struct TodoDataModel {
    
}

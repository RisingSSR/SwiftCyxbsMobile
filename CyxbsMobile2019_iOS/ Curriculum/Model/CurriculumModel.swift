//
//  CurriculumModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurriculumModel {
    
    var inWeek: Int = 0
    
    var inSections: IndexSet = .init()
    
    var period = 0...0

    var course: String = ""
    
    var classRoom: String = ""

    var type: String = ""
    
    var courseID: String?
    
    var rawWeek: String?
    
    var teacher: String?
    
    var lesson: String?
}

extension CurriculumModel {
    
    init(json: JSON) {
        inWeek = json["hash_day"].intValue + 1
        
        json["week"].arrayValue.forEach { eachWeek in
            inSections.insert(eachWeek.intValue)
        }
        
        let location = json["begin_lesson"].intValue
        let lenth = json["period"].intValue
        period = location...(location + lenth)
        
        course = json["course"].stringValue
        classRoom = json["classroom"].stringValue
        
        type = json["type"].stringValue
        courseID = json["course_num"].string
        rawWeek = json["rawWeek"].string
        teacher = json["teacher"].string
        lesson = json["lesson"].string
    }
}

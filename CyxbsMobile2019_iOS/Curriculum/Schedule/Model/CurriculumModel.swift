//
//  CurriculumModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurriculumModel: Codable, Equatable {
    
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
        period = location...(location + lenth - 1)
        
        course = json["course"].stringValue
        classRoom = json["classroom"].stringValue
        
        type = json["type"].stringValue
        courseID = json["course_num"].string
        rawWeek = json["rawWeek"].string
        teacher = json["teacher"].string
        lesson = json["lesson"].string
    }
    
    var jsonStr: String {
        let dic: [String : Any] = [
            "hash_day": inWeek,
            "week": Array(inSections),
            "begin_lesson": period.lowerBound,
            "period": period.count - 1,
            "course": course,
            "classroom": classRoom,
            "type": type,
            "course_num": courseID ?? "cyxbs\(Date().timeIntervalSince1970)\(arc4random())",
            "rawWeek": rawWeek ?? "",
            "teacher": teacher ?? "",
            "lesson": lesson ?? ""
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: [.prettyPrinted]) else { return "" }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

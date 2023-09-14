//
//  CurriculumModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CurriculumModel: Codable {
    
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

extension CurriculumModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(inWeek)
        hasher.combine(inSections)
        hasher.combine(period)
        hasher.combine(course)
        hasher.combine(classRoom)
        hasher.combine(type)
        hasher.combine(courseID)
        hasher.combine(rawWeek)
        hasher.combine(teacher)
        hasher.combine(lesson)
    }

    static func == (lhs: CurriculumModel, rhs: CurriculumModel) -> Bool {
        return lhs.inWeek == rhs.inWeek &&
            lhs.inSections == rhs.inSections &&
            lhs.period == rhs.period &&
            lhs.course == rhs.course &&
            lhs.classRoom == rhs.classRoom &&
            lhs.type == rhs.type &&
            lhs.courseID == rhs.courseID &&
            lhs.rawWeek == rhs.rawWeek &&
            lhs.teacher == rhs.teacher &&
            lhs.lesson == rhs.lesson
    }
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
}

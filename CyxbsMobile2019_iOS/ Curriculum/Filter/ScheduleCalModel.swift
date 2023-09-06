//
//  ScheduleCalModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct ScheduleCalModel {
    
    var stu: SearchStudentModel?
    
    var inWeek: Int = 0
    
    var inSection: Int = 0
    
    var period = 0...0

    var course: String = ""
    
    var classRoom: String = ""

    var type: String = ""
    
    var courseID: String?
    
    var rawWeek: String?
    
    var teacher: String?
    
    var lesson: String?
}


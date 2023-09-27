//
//  ScheduleDataFetch.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/9/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

func sectionString(withSection section: Int) -> String {
    if section >= 1 {
        let formatter = NumberFormatter()
        formatter.locale = .cn
        formatter.numberStyle = .spellOut
        if let num = formatter.string(from: section as NSNumber) {
            return "第" + num + "周"
        }
    }
    return "整学期"
}

func monthString(withSection section: Int, from: Date?) -> String {
    guard let from, section >= 1 else { return "学期" }
    let currenDay = Calendar.current.date(byAdding: .day, value: (section - 1) * 7, to: from) ?? Date()
    return currenDay.string(locale: .cn, format: "M月")
}

func date(withSection section: Int, week: Int) -> Date {
    guard section >= 1 else {
        return Calendar.current.date(bySetting: .day, value: (week - 1) * 7 + week - 1, of: Date()) ?? Date()
    }
    return Calendar.current.date(byAdding: .day, value: (section - 1) * 7 + (week - 1), to: Date()) ?? Date()
}

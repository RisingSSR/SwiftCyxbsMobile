//
//  ScheduleWidgetEntryView.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import SwiftUI
import WidgetKit

struct ScheduleWidgetEntryView: View {
    
    let mappy: ScheduleMaping
    
    let section: Int
    
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
//        case .systemSmall:
//            ScheduleSystemSmall()
        case .systemLarge:
            ScheduleSystemLarge(mappy: mappy, section: section)
            EmptyView()
        default:
            EmptyView()
        }
    }
    
    init(entry: ScheduleProvider.Entry) {
        
        mappy = ScheduleMaping()
        for model in entry.models {
            mappy.maping(model)
        }
        
        section = entry.section ?? mappy.nowWeek
    }
}

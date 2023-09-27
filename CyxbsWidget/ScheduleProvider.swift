//
//  Provider.swift
//  CyxbsWidget
//
//  Created by SSR on 2022/12/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

typealias ScheduleWidgetConfiguration = ConfigurationIntent

struct ScheduleProvider: IntentTimelineProvider {    
    
    func placeholder(in context: Context) -> ScheduleTimelineEntry {
        let entry = ScheduleTimelineEntry(date: Date())
        return entry
    }
    
    func getSnapshot(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (ScheduleTimelineEntry) -> ())  {
        
        var entry = ScheduleTimelineEntry(date: Date(), configuration: configuration)
      
        if let model = CacheManager.shared.getCodable(ScheduleModel.self, in: .init(rootPath: .bundle, file: "sno2021215154.data")) {
            
            entry.models.append(model)
        }
        
        completion(entry)
    }
    
    func getTimeline(for configuration: ScheduleWidgetConfiguration, in context: Context, completion: @escaping (Timeline<ScheduleTimelineEntry>) -> ()) {
        
        guard let mainSno = Constants.mainSno else { return }
        
        ScheduleModel.request(sno: mainSno) { response in
            let currentDate = Date()
            var entries: [ScheduleTimelineEntry] = []
            
            switch response {
            case .success(let model):
                
                for hourOffset in 0 ..< 12 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? currentDate
                    
                    var entry = ScheduleTimelineEntry(date: entryDate, configuration: configuration)
                    entry.models.append(model)
                    
                    entries.append(entry)
                }
                
            case .failure(let netError):
                
                var entry = ScheduleTimelineEntry(date: currentDate, configuration: configuration)
                entry.error = netError
                entries.append(entry)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

//
//  ScheduleGroupModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/8.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ScheduleGroupModel {
    
    enum Priority: Int, Comparable {
        
        case mainly = 0
        
        case custom = 1
        
        case others = 2
        
        static func < (lhs: ScheduleGroupModel.Priority, rhs: ScheduleGroupModel.Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    var name: String
    
    typealias IndexPathToPriorityCalMap = [IndexPath: Dictionary<Priority, ScheduleCalModel>.Element]
    
    private(set) var mapPage: IndexPathToPriorityCalMap = [:]
    
    private var snoMap: [Priority: Dictionary<Priority, ScheduleModel>.Element] = [:]
    
    private var outPage: [IndexPath: [IndexPathToPriorityCalMap.Element]] = [:]
    
    init(name: String) {
        self.name = name
    }
}

extension ScheduleGroupModel {
    
    func group(with model: ScheduleModel, prepare cals: [ScheduleCalModel]? = nil, priority: Priority = .mainly) {
        snoMap[priority] = (priority, model)
        let cals = cals ?? model.calModels
        for cal in cals {
            for idx in cal.curriculum.period {
                let indexPath = IndexPath(indexes: [cal.inSection, cal.curriculum.inWeek, idx])
                guard let old = mapPage[indexPath] else {
                    mapPage[indexPath] = (priority, cal)
                    continue
                }
                if old.key < priority { continue }
                if old.key == priority {
                    if old.value.curriculum.period.count > cal.curriculum.period.count {
                        continue
                    }
                }
                outPage[indexPath] = outPage[indexPath] ?? []
                outPage[indexPath]!.append((indexPath, old))
                mapPage[indexPath] = (priority, cal)
            }
        }
    }
}

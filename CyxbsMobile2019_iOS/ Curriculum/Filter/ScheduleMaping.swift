//
//  ScheduleMaping.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

// MARK: ~.Priority

extension ScheduleMaping {
    
    enum Priority: Int, Comparable {
        
        case mainly = 0
        
        case custom = 1
        
        case others = 2
        
        static func < (lhs: ScheduleMaping.Priority, rhs: ScheduleMaping.Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
}

// MARK: ~.Collection

extension ScheduleMaping {
    
    struct Collection: Equatable {
        
        let cal: ScheduleCalModel
        
        let location: Int
        
        var lenth: Int = 1
        
        let priority: Priority
        
        var count: Int = 1
        
        init(cal: ScheduleCalModel, location: Int, priority: Priority) {
            self.cal = cal
            self.location = location
            self.priority = priority
        }
        
        static func == (lhs: ScheduleMaping.Collection, rhs: ScheduleMaping.Collection) -> Bool {
            lhs.cal === rhs.cal
        }
    }
}

// MARK: ScheduleMaping

class ScheduleMaping {
    
    var name: String? = nil
    
    var start: Date? = nil
    
    // if you don't want to have a diffirent views, set it to false
    // otherwise, your time complexity will approach O(n ^ 3)
    var checkPriority: Bool = true
    
    // {2021215154, .system} -> .mainly
    private var scheduleModelMap: [ScheduleModel: Priority] = [:]
    
    // (section, week) -> {ScheduleCalModel, ScheduleCalModel, nil, ...}
    private var mapTable: [IndexPath: [Collection?]] = [:]
    
    private var oldValues: [Collection] = []
    
    // the final data to show on view
    private var finalData: [[Collection]] = [[]]
    var datas: [[Collection]] {
        if !didFinished { finish() }
        return finalData
    }
    
    // if didFinished, mapTable is available
    private var didFinished: Bool = false
}

// MARK: search back

extension ScheduleMaping {
    
    // search priority on scheduleModelMap, O(n)
    func getPriority(for sno: String, customType: ScheduleModel.CustomType) -> Priority? {
        scheduleModelMap.first { $0.key.sno == sno && $0.key.customType == customType }?.value
    }
}

// MARK: mapping

extension ScheduleMaping {
    
    // map a ScheduleModel on mapTable, O(n + m), n: section, m: lenth
    func maping(_ model: ScheduleModel, prepare cals: [ScheduleCalModel]? = nil, priority: Priority = .mainly) {
        if model.customType == .system {
            start = model.start
        }
        if scheduleModelMap[model] != nil { return }
        didFinished = false
        scheduleModelMap[model] = priority
        let cals = cals ?? model.calModels
        for cal in cals {
            for idx in cal.curriculum.period {
                let pointCal = Collection(cal: cal, location: idx, priority: priority)
                map(pCal: pointCal, in: idx)
            }
        }
    }
    
    private func map(pCal: Collection, in location: Int) {
        let indexPath = IndexPath(indexes: [pCal.cal.inSection, pCal.cal.curriculum.inWeek])
        var ary = mapTable[indexPath] ?? []
        if ary.count <= location {
            for _ in ary.count ... location {
                ary.append(nil)
            }
        }
        
        // do not check priority to layout
        
        if !checkPriority {
            abandon_the_old_for_the_new()
            return
        }
        
        // if is old exist
        
        guard let old = ary[location] else {
            abandon_the_old_for_the_new()
            return
        }
        
        // abandon the old for the new
        
        if pCal.priority < old.priority {
            abandon_the_old_for_the_new(old: old)
            return
        }
        
        if pCal.priority == old.priority {
            if pCal.cal.curriculum.period.count >= old.cal.curriculum.period.count {
                abandon_the_old_for_the_new(old: old)
                return
            }
        }
        
        firm_and_unshakable(old: &ary[location]!)
        
        func abandon_the_old_for_the_new(old: Collection? = nil) {
            var new = pCal
            if let old {
                oldValues.append(old)
                new.count += 1
            }
            ary[location] = new
            mapTable[indexPath] = ary
        }
        
        func firm_and_unshakable(old: inout Collection) {
            oldValues.append(pCal)
            old.count += 1
        }
    }
    
    // finished mapTable to finalData
    func finish() {
        if didFinished { return }
        didFinished = true
        finalData = [[]]
        
        for each in mapTable {
            if finalData.count <= each.key[0] {
                for _ in finalData.count ... each.key[0] {
                    finalData.append([])
                }
            }
            
            if each.value.count <= 1 { continue }
            
            var oldValue = each.value[0]
            
            for newIndex in 1 ..< each.value.count {
                let newValue = each.value[newIndex]
                if oldValue != newValue {
                    if let newValue {
                        var collection = Collection(cal: newValue.cal, location: newIndex, priority: newValue.priority)
                        collection.count = newValue.count
                        finalData[each.key[0]].append(collection)
                    }
                } else {
                    if newValue != nil, finalData[each.key[0]].count > 0 {
                        finalData[each.key[0]][finalData[each.key[0]].count - 1].lenth += 1
                    }
                }
                oldValue = newValue
            }
        }
    }
}

//
//  ScheduleMaping.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ScheduleMaping {
    
    enum Priority: Int, Comparable {
        
        case mainly = 0
        
        case custom = 1
        
        case others = 2
        
        static func < (lhs: ScheduleMaping.Priority, rhs: ScheduleMaping.Priority) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    var name: String? = nil
    
    var start: Date? = nil
    
    // if you don't want to have a diffirent views, set it to false
    // otherwise, your time complexity will approach O(n ^ 3)
    var checkPriority: Bool = true
    
    // .mainly -> {2021215154, system, ...}
    private var scheduleModelMap: [Priority: ScheduleModel] = [:]
    
    // (section, week) -> {ScheduleCalModel, ScheduleCalModel, nil, ...}
    private var mapTable: [IndexPath: [ScheduleCalModel?]] = [:]
    
    // if checkPriority is enable, oldTable will cache unused cal in which location it should to stay
    private var oldTable: [(m: ScheduleCalModel, l: Int)] = []
    
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
        scheduleModelMap.first { $0.value.sno == sno && $0.value.customType == customType }?.key
    }
}

// MARK: ~.Collection

extension ScheduleMaping {
    
    class Collection {
        
        let cal: ScheduleCalModel
        
        var location: Int
        
        var lenth: Int = 1
        
        var priority: Priority
        
        init(cal: ScheduleCalModel, location: Int, priority: Priority) {
            self.cal = cal
            self.location = location
            self.priority = priority
        }
    }
}

// MARK: mapping

extension ScheduleMaping {
    
    // map a ScheduleModel on mapTable, O(n + m), n: section, m: lenth
    func maping(_ model: ScheduleModel, prepare cals: [ScheduleCalModel]? = nil, priority: Priority = .mainly) {
        if model.customType == .system {
            start = model.start
        }
        didFinished = false
        scheduleModelMap[priority] = model
        let cals = cals ?? model.calModels
        for cal in cals {
            for idx in cal.curriculum.period {
                map(cal: cal, in: idx)
            }
        }
    }
    
    // map a ScheduleCalModel on a locate of mapTable
    private func map(cal: ScheduleCalModel, in location: Int, with priority: Priority = .mainly) {
        let indexPath = IndexPath(indexes: [cal.inSection, cal.curriculum.inWeek])
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
        
        // abandon the old for the new
        
        guard let old = ary[location] else {
            abandon_the_old_for_the_new()
            return
        }
        
        guard let oldPriority = getPriority(for: old.sno, customType: old.customType) else {
            abandon_the_old_for_the_new(old: old)
            return
        }
        
        if priority < oldPriority {
            abandon_the_old_for_the_new(old: old)
            return
        }
        
        if priority == oldPriority {
            if cal.curriculum.period.count >= old.curriculum.period.count {
                abandon_the_old_for_the_new(old: old)
            }
        }
        
        // firm and unshakable
        
        firm_and_unshakable()
        
        // Private function
        
        func abandon_the_old_for_the_new(old: ScheduleCalModel? = nil) {
            if let old { oldTable.append((m: old, l: location)) }
            ary[location] = cal
            mapTable[indexPath] = ary
        }
        
        func firm_and_unshakable() {
            oldTable.append((m: cal, l: location))
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
                        let priority = getPriority(for: newValue.sno, customType: newValue.customType) ?? .mainly
                        let collection = Collection(cal: newValue, location: newIndex, priority: priority)
                        finalData[each.key[0]].append(collection)
                    }
                } else {
                    if newValue != nil {
                        finalData[each.key[0]].last?.lenth += 1
                    }
                }
                oldValue = newValue
            }
        }
    }
}

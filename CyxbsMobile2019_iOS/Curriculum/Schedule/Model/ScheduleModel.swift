//
//  ScheduleModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: ~.CustomType

extension ScheduleModel {
    
    enum CustomType: Codable, Hashable {
        
        case system
        
        case custom
    }
}

// MARK: ScheduleModel

struct ScheduleModel: Codable {
    
    var sno: String
    
    var customType: CustomType = .system
    
    var nowWeek: Int = 0 {
        didSet {
            var calculateWeek = nowWeek
            if calculateWeek == 0 { calculateWeek = 1 }
            
            if customType == .custom { return }
            let calendar = Calendar(identifier: .gregorian)
            let currentDate = Date()
            
            var todayWeekDay = calendar.dateComponents([.weekday], from: currentDate).weekday ?? 2
            if todayWeekDay == 1 { todayWeekDay = 8 }
            todayWeekDay -= 1
            
            let start = calendar.date(byAdding: .day, value: -((calculateWeek - 1) * 7 + todayWeekDay - 1), to: currentDate) ?? currentDate
            
            self.start = start
            Constants.start = start
        }
    }
    
    private(set) var start: Date?
    
    var student: SearchStudentModel? = nil
    
    var curriculum: [CurriculumModel] = []
    
    init(sno: String, customType: CustomType = .system) {
        self.sno = sno
        self.customType = customType
    }
}

extension ScheduleModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(sno)
        hasher.combine(customType)
    }
}

extension ScheduleModel {
    
    static func filePath(rootPath: CacheManager.RootPath = .document, sno: String) -> CacheManager.FilePath {
        .init(rootPath: rootPath, file: "ScheduleModel/sno\(sno).data")
    }
    
    static func getFromCache(rootPath: CacheManager.RootPath = .document, sno: String) -> Self? {
        CacheManager.shared.getCodable(self, in: filePath(rootPath: rootPath, sno: sno))
    }
    
    func toCache(rootPath: CacheManager.RootPath = .document, specialName: String? = nil) {
        let specialName = specialName ?? sno
        CacheManager.shared.cache(codable: self, in: ScheduleModel.filePath(rootPath: rootPath, sno: specialName))
    }
}

// MARK: request

extension ScheduleModel {
    
    static func request(snos: Set<String>, handle: @escaping (NetResponse<[ScheduleModel]>) -> Void) {
        
        var modelAry = [ScheduleModel]()
        
        let que = DispatchQueue(label: "ScheduleModel.magipoke_jwzx_kebiao.snos", qos: .default, attributes: .concurrent)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        for sno in snos {
            
            que.async {
                
                request(sno: sno) { response in
                    switch response {
                    case .success(let model):
                        modelAry.append(model)
                    case .failure(let netError):
                        handle(.failure(netError))
                    }
                    
                    semaphore.signal()
                }
            }
        }
        
        que.async(flags: .barrier) {
            
            for _ in snos {
                
                semaphore.wait()
            }
        }
        
        que.async {
            
            DispatchQueue.main.async {
                
                handle(.success(modelAry))
            }
        }
    }
    
    static func request(sno: String, handle: @escaping (NetResponse<ScheduleModel>) -> Void) {
        
        var scheduleModel = ScheduleModel(sno: sno)
        
        let que = DispatchQueue(label: "ScheduleModel.magipoke_jwzx_kebiao", qos: .unspecified, attributes: .concurrent)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        que.async {
            
            SearchStudentModel.request(info: sno) { response in
                switch response {
                case .success(let model):
                    scheduleModel.student = model.first
                case .failure(let netError):
                    handle(.failure(netError))
                }
                
                semaphore.signal()
            }
            
            HttpManager.shared.magipoke_jwzx_kebiao(stu_num: sno).ry_JSON { response in
                switch response {
                case .success(let json):
                    scheduleModel.sno = json["stuNum"].stringValue
                    scheduleModel.nowWeek = json["nowWeek"].intValue
                    if let ary = json["data"].array?.map(CurriculumModel.init(json:)) {
                        scheduleModel.curriculum = ary
                    }
                case .failure(let netError):
                    handle(.failure(netError))
                }
                
                semaphore.signal()
            }
            
            semaphore.wait()
            semaphore.wait()
        }
        
        que.async(flags: .barrier) {
            
            DispatchQueue.main.async {
                
                handle(.success(scheduleModel))
            }
        }
    }
    
    static func requestCustom(handle: @escaping (NetResponse<ScheduleModel>) -> Void) {
        HttpManager.shared.magipoke_reminder_Person_getTransaction().ry_JSON { response in
            switch response {
            case .success(let model):
                
                print("model \(model)")
                
            case .failure(let netError):
                print("error \(netError)")
            }
        }
    }
}

extension ScheduleModel {
    
    var calModels: [ScheduleCalModel] { ScheduleCalModel.create(with: self) }
    
    static func calCourseWillBeTaking(with calModels: [ScheduleCalModel]) -> ScheduleCalModel? {
        let currentDate = Date()
        var cal: ScheduleCalModel? = nil
        for calModel in calModels {
            if let startDate = calModel.startCal, let endDate = calModel.endCal {
                if Calendar.current.isDateInToday(startDate) {
                    if startDate <= currentDate && currentDate <= endDate {
                        return calModel
                    }
                    if currentDate <= startDate {
                        guard let old = cal else {
                            cal = calModel
                            continue
                        }
                        if let calStart = old.start, startDate < calStart {
                            cal = calModel
                        }
                    }
                }
            }
        }
        return cal
    }
}

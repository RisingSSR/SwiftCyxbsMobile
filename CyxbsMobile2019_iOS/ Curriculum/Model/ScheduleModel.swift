//
//  ScheduleModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ScheduleModel: Codable {
    
    enum CustomType: Codable {
        
        case system
        
        case custom
    }
    
    var sno: String = ""
    
    var customType: CustomType = .system
    
    var nowWeek: Int = 0 {
        didSet {
            if customType == .custom { return }
            let calendar = Calendar.current
            var currentDate = Date()
            // 因为国外是以周日作为第一天，如果是周日，则要将日期向上一周移动一次
            if calendar.component(.weekday, from: currentDate) == 1 {
                currentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
            }
            // 然后将日期移动到当周的周一
            currentDate = calendar.date(bySetting: .weekday, value: 2, of: currentDate) ?? currentDate
            // 根据nowWeek增加一段时间
            currentDate = calendar.date(byAdding: .weekOfYear, value: -nowWeek, to: currentDate, wrappingComponents: true) ?? currentDate
            start = currentDate
            
            Constants.start = start
        }
    }
    
    private(set) var start: Date?
    
    var student: SearchStudentModel? = nil
    
    var curriculum: [CurriculumModel] = []
}

extension ScheduleModel {
    
    static func filePath(rootPath: CacheManager.RootPath = .document, sno: String) -> CacheManager.FilePath {
        .init(rootPath: rootPath, file: "ScheduleModel/sno\(sno).data")
    }
    
    static func getFromCache(rootPath: CacheManager.RootPath = .document, sno: String) -> Self? {
        CacheManager.shared.getCodable(self, in: filePath(rootPath: rootPath, sno: sno))
    }
    
    func toCache(rootPath: CacheManager.RootPath = .document) {
        CacheManager.shared.cache(codable: self, in: ScheduleModel.filePath(rootPath: rootPath, sno: sno))
    }
    
    static func request(sno: String, handle: @escaping (NetResponse<ScheduleModel>) -> Void) {
        
        let group = DispatchGroup()
        var scheduleModel = ScheduleModel()
        group.enter()
        SearchStudentModel.request(info: sno) { response in
            switch response {
            case .success(let model):
                scheduleModel.student = model.first
            case .failure(let netError):
                handle(.failure(netError))
            }
            group.leave()
        }
        
        group.enter()
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
            group.leave()
        }
        
        group.notify(queue: .main) {
            handle(.success(scheduleModel))
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

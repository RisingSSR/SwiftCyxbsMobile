//
//  ScheduleModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ScheduleModel {
    
    var sno: String = ""
    
    var nowWeek: Int = 0 {
        didSet {
            let calendar = Calendar.current
            let currentDate = Date()
            
            var dateComponents = DateComponents()
            dateComponents.weekday = 2
            
            if nowWeek != 0 {
                dateComponents.weekOfYear = calendar.component(.weekOfYear, from: currentDate) - nowWeek
            }
            
            let startOfWeek = calendar.nextDate(after: currentDate, matching: dateComponents, matchingPolicy: .nextTimePreservingSmallerComponents)
            start = startOfWeek
        }
    }
    
    var start: Date?
    
    var student: SearchStudentModel? = nil
    
    var curriculum: [CurriculumModel] = []
}

extension ScheduleModel {
    
    @discardableResult
    mutating func set(json: JSON) -> Self {
        sno = json["stuNum"].stringValue
        nowWeek = json["nowWeek"].intValue
        if let ary = json["data"].array?.map(CurriculumModel.init(json:)) {
            curriculum = ary
        }
        return self
    }
}

extension ScheduleModel {
    
    static func request(sno: String, handle: @escaping (RYResponse<ScheduleModel>) -> Void) {
        
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
            case .success(let model):
                scheduleModel.set(json: model)
                CacheManager.shared.cache(json: model, in: .init(rootPath: .document, file: "ScheduleModel/sno\(scheduleModel.sno)"))
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

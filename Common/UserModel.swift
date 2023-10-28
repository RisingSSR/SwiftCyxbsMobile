//
//  UserModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    
    static var `defualt` = UserModel()
    
    private init() { }
    
    var person: PersonModel?
    
    var token: TokenModel?
    
    lazy var customSchedule: ScheduleModel = {
        CacheManager.shared.getCodable(ScheduleModel.self, in: .schedule(sno: "custom"))
        ?? .init(sno: token?.stuNum ?? "临时学生", customType: .custom)
    }() {
        didSet {
            CacheManager.shared.cache(codable: customSchedule, in: .schedule(sno: "custom"))
        }
    }
}

//
//  UserDefualtsManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class UserDefualtsManager {
    
    static let shared = UserDefualtsManager()
    
    static let widget = UserDefualtsManager("group.com.mredrock.cyxbs.widget")
    
    private init(_ suiteName: String? = nil) {
        if let suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            userDefaults = UserDefaults.standard
        }
    }
    
    private let userDefaults: UserDefaults
}

extension UserDefualtsManager {
    
    private func set(_ obj: Any?, forKey key: String) {
        userDefaults.set(obj, forKey: key)
    }
    
    private func get(key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

extension UserDefualtsManager {
    
    /// 系统版本（用于不同版本迭代时判断）
    var systemVersion: String? {
        set { set(newValue, forKey: "SYSTEM_VERSION") }
        get { get(key: "SYSTEM_VERSION") as? String }
    }
    
    /// 上次打开App时间（用于不同天打开App时判断）
    var latestOpenApp: Date? {
        set { set(newValue, forKey: "LATEST_OPEN_APP") }
        get { get(key: "LATEST_OPEN_APP") as? Date }
    }
    
    /// 主学生学号（用于一级缓存）
    var mainStudentSno: String? {
        set { set(newValue, forKey: "MAIN_STUDENT_SNO") }
        get { get(key: "MAIN_STUDENT_SNO") as? String }
    }
}

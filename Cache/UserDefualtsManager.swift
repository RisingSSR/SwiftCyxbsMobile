//
//  UserDefualtsManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    static let widget = UserDefaultsManager(Constants.widgetGroupID)
    
    private init(_ suiteName: String? = nil) {
        if let suiteName {
            userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            userDefaults = UserDefaults.standard
        }
    }
    
    private let userDefaults: UserDefaults
}

extension UserDefaultsManager {
    
    private func set(_ obj: Any?, forKey key: String) {
        userDefaults.set(obj, forKey: key)
    }
    
    private func get(key: String) -> Any? {
        userDefaults.object(forKey: key)
    }
}

extension UserDefaultsManager {
    
    /// 获取当前包版本（用于App软更新时判断）
    var bundleShortVersion: String? {
        set { set(newValue, forKey: "BUNDLE_SHORT_VERSION") }
        get { get(key: "BUNDLE_SHORT_VERSION") as? String }
    }
    
    /// 上次打开App时间（用于不同天打开App时判断）
    var latestOpenApp: Date? {
        set { set(newValue, forKey: "LATEST_OPEN_APP") }
        get { get(key: "LATEST_OPEN_APP") as? Date }
    }
}

extension UserDefaultsManager {
    
    /// 主学生学号（用于一级缓存）
    var mainStudentSno: String? {
        set { set(newValue, forKey: "MAIN_STUDENT_SNO") }
        get { get(key: "MAIN_STUDENT_SNO") as? String }
    }
        
    /// 上一次请求主学号时间（用于一级缓存）
    func cache(latestRequest date: Date, sno: String) {
        set(date, forKey: "LATEST_REQUEST_SNO_\(sno)")
    }
    func latestRequest(sno: String) -> Date? {
        get(key: "LATEST_REQUEST_SNO__\(sno)") as? Date
    }
    
}

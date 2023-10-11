//
//  Constants.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

struct Constants {
    
    private init() { }
    
    static let widgetGroupID: String = "group.com.mredrock.cyxbs.widget"
    
}

extension Constants {
    
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var deviceUUID: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var systemName: String {
        UIDevice.current.systemName
    }
    
    static var systemVersion: String {
        UIDevice.current.systemVersion
    }
    
    static var bundleShortVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

// MARK: custom

extension Constants {
    
    /* !!!: 清理缓存
       若下一个版本需要清理一下以前的缓存信息，则需要设置为true
     */
    static let cleanInNextVersion: Bool = true
}

extension Constants {
    
    /// 获得token
    static var token: String? = {
        UserDefaultsManager.shared.token
    }() {
        didSet {
            UserDefaultsManager.shared.token = token
        }
    }
    
    /// 获得主学号
    static var mainSno: String? = {
        UserDefaultsManager.widget.mainStudentSno
    }() {
        didSet {
            UserDefaultsManager.widget.mainStudentSno = mainSno
        }
    }
}

extension Constants {
    
    /* 获得开学的时间
     在 ScheduleModel.nowWeek.didSet 中赋值
     */
    static var start: Date? = nil
    
    /* 获取当前周（可负）
     在设置了 start 过后得到
     */
    static var nowWeek: Int? {
        guard let start = start else { return nil }
        
        let calendar = Calendar(identifier: .gregorian)
        
        let days = calendar.dateComponents([.day], from: start, to: Date()).day ?? 0
        
        return days / 7 + 1
    }
}

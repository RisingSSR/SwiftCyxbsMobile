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
        
        let calendar = Calendar.current
        var currentDate = Date()
        // 因为国外是以周日作为第一天，如果是周日，则要将日期向上一周移动一次
        if calendar.component(.weekday, from: start) == 1 {
            currentDate = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
        }
        // 然后将日期移动到当周的周一
        currentDate = calendar.date(bySetting: .weekday, value: 2, of: currentDate) ?? currentDate
        // 计算当前日期与开始日期之间的周数差
        if let weekOfYear = calendar.dateComponents([.weekOfYear], from: start, to: currentDate).weekOfYear {
            return weekOfYear + 1
        }
        return nil
    }
}

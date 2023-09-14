//
//  FoundationEX.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

extension Locale {
    static let cn: Self = .init(identifier: "zh_CN")
}

extension Date {
    
    func string(locale: Locale, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

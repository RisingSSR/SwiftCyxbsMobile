//
//  HttpManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Alamofire

struct HttpManager {
    
    static let shared = HttpManager()
    
    private init() { }
}

// MARK: 课表

extension HttpManager {
    
    @discardableResult
    func magipoke_jwzx_kebiao(stu_num: String) -> DataRequest {
        let parameters: [String: String] = [
            "stu_num": stu_num
        ]
        return SessionManager.shared.request(APIConfig.api("/magipoke-jwzx/kebiao"), parameters: parameters)
    }
}

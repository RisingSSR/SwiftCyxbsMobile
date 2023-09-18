//
//  HttpManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Alamofire

struct HttpManager {
    
    static var shared: HttpManager {
        if let ip = AliyunConfig.ip(byHost: APIConfig.environment.host) {
            shared_p.session.add(host: ip)
        }
        return shared_p
    }
    
    private static let shared_p = HttpManager()
    
    private let session = SessionManager.shared
    
    private init() { }
}

// MARK: 课表

extension HttpManager {
    
    /// 获取课表
    @discardableResult
    func magipoke_jwzx_kebiao(stu_num: String) -> DataRequest {
        let parameters: [String: String] = [
            "stu_num": stu_num
        ]
        return session.request(APIConfig.api("/magipoke-jwzx/kebiao"), method: .post, parameters: parameters)
    }
    
    /// 查询同学信息
    @discardableResult
    func magipoke_text_search_people(stu: String) -> DataRequest {
        let parameters: [String: String] = [
            "stu": stu
        ]
        return session.request(APIConfig.api("/magipoke-text/search/people"), parameters: parameters)
    }
}

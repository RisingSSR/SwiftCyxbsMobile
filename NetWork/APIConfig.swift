//
//  APIConfig.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct APIConfig {
    
    private init() { }
    
    enum Environment {
        
        case BE_PROD         // 生产环境
        
        case BE_DEV          // 测试环境
        
        case CLOUD(String)   // 容灾环境
        
        var url: String {
            switch self {
            case .BE_PROD:
                return "https://be-prod.redrock.cqupt.edu.cn"
            case .BE_DEV:
                return "https://be-dev.redrock.cqupt.edu.cn"
            case .CLOUD(let base_url):
                return "https://\(base_url)"
            }
        }
    }
    
    static var environment: Environment = {
        #if DEBUG
        return .BE_DEV
        #else
        return .BE_PROD
        #endif
    }()
    
    static func askCloud(success: @escaping (Environment) -> Void) {
        AF.request("https://be-prod.redrock.team/cloud-manager/check").ry_JSON { response in
            if let value = response.value {
                if let base_url = value.dictionary?["base_url"]?.string {
                    success(.CLOUD(base_url))
                    return
                }
            }
            success(.BE_PROD)
        }
    }
    
    static func api(_ api: String) -> String {
        return environment.url + api
    }
}

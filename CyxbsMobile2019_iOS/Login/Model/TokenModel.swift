//
//  TokenModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TokenModel: Codable {
    
    var stuNum: String
    
    var gender: String
    
    var domain: String = "magipoke"
    
    var redid: String
    
    var exp: TimeInterval
    
    var iat: TimeInterval
    
    var sub: String = "web"
    
    var token: String
    
    var refreshToken: String
}

extension TokenModel {
    
    init(token: String, refreshToken: String) {
        self.token = token
        self.refreshToken = refreshToken
        let payload = token.components(separatedBy: ".").first ?? ""
        let data = Data(base64Encoded: payload) ?? Data()
        let dic = JSON(data)
        stuNum = dic["Data"]["stu_num"].stringValue
        gender = dic["Data"]["gender"].stringValue
        domain = dic["Domain"].stringValue
        redid = dic["Redid"].stringValue
        exp = TimeInterval(dic["exp"].stringValue) ?? 0
        iat = TimeInterval(dic["iat"].stringValue) ?? 0
        sub = dic["sub"].stringValue
    }
}

extension TokenModel {
    
    func toCache() {
        CacheManager.shared.cache(codable: self, in: .init(rootPath: .widget, file: "token_model"))
        Constants.mainSno = stuNum
        Constants.token = token
        SessionManager.shared.token = token
        UserDefaultsManager.shared.refreshToken = refreshToken
    }
    
    static var fromCache: Self? {
        if let tokenModel = CacheManager.shared.getCodable(TokenModel.self, in: .init(rootPath: .widget, file: "token_model")) {
            return tokenModel
        }
        
        if let token = Constants.token,
            let refreshToken = UserDefaultsManager.shared.refreshToken {
            return TokenModel(token: token, refreshToken: refreshToken)
        }
        
        return nil
    }
}

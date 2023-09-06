//
//  SessionManager.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/9/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SessionManager: Session {
    
    static let shared = SessionManager()
    
    @discardableResult
    func add(token: String) -> Self {
        sessionConfiguration.headers.add(.authorization(bearerToken: token))
        return self
    }
}

extension DataRequest {
    
    @discardableResult
    func ry_JSON(decoder: DataDecoder = JSONDecoder(), completionHandler: @escaping (AFDataResponse<JSON>) -> Void) -> Self {
        responseDecodable(of: JSON.self, decoder: decoder, completionHandler: completionHandler)
    }
}

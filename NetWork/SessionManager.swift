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
    
    static var error_500_count = 0
    
    @discardableResult
    func ry_JSON(decoder: DataDecoder = JSONDecoder(), completionHandler: @escaping (NetResponse<JSON>) -> Void) -> Self {
        responseDecodable(of: JSON.self, decoder: decoder) { response in
            if let value = response.value {
                completionHandler(.success(value))
            } else {
                let error = NetError(request: response.request, response: response.response, error: response.error)
                completionHandler(.failure(error))
            }
            
            if let code = response.error?.responseCode {
                if (500..<600).contains(code) {
                    DataRequest.error_500_count += 1
                    if DataRequest.error_500_count >= 5 {
                        APIConfig.askCloud { enviroment in
                            APIConfig.environment = enviroment
                        }
                    }
                }
            }
        }
    }
}

struct NetError: Error {
    
    let request: URLRequest?

    let response: HTTPURLResponse?
    
    let error: AFError?
}

enum NetResponse<Model> {
    
    case success(Model)
    
    case failure(NetError)
}

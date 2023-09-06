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
    func ry_JSON(decoder: DataDecoder = JSONDecoder(), completionHandler: @escaping (RYResponse<JSON>) -> Void) -> Self {
        responseDecodable(of: JSON.self, decoder: decoder) { response in
            if let value = response.value {
                completionHandler(.success(value))
            } else {
                let error = NetError(request: response.request, response: response.response, error: response.error)
                completionHandler(.failure(error))
            }
        }
    }
}

struct NetError: Error {
    
    let request: URLRequest?

    let response: HTTPURLResponse?
    
    let error: AFError?
}

enum RYResponse<Model> {
    
    case success(Model)
    
    case failure(NetError)
}

//
//  UserModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2023/10/7.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    
    static var `defualt` = UserModel()
    
    private init() { }
    
    var person: PersonModel?
    
    var token: TokenModel?
}

//
//  LoginModel.swift
//  BootcampCapstone
//
//  Created by Solomon Chambers on 9/17/26.
//

import Foundation

struct LoginModel: Codable {
    var username: String = ""
    var password: String = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "loginId"
        case password
    }
    
}

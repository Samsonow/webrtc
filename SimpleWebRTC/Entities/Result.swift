//
//  Result.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

struct Result<T: Codable>: Codable {
    let result: T
}

struct Token: Codable {
    let token: String
}

struct TempPassword: Codable {
    let temp_password: String
}

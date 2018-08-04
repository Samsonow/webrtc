//
//  BackendError.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

struct BackendError: Codable {
    let error: Description
}

struct Description: Codable {
    let code: String
    let message: String
}

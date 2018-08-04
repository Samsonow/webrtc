//
//  NetworkError.swift
//  SimpleWebRTC
//
//  Created by Zhenya on 02.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case error
    case decode
    case message(String)
}

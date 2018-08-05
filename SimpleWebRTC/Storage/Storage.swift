//
//  Storage.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation
class Storage {
    
    static let shared: Storage = Storage()
    private var token: String?
    private let keyToken: String = "token"
    
    var user: User?
    
    private init() {}
    
    func getToken() -> String? {
        if let token = self.token {
            return token
        } else {
            let token = UserDefaults.standard.string(forKey: keyToken)
            self.token = token
            return token
        }

    }
    
    func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: keyToken)
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: keyToken)
        token = nil
        user = nil
    }
    
}

//
//  Product.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    var confirmed_price_seller: Float?
    
    var confirmed_price_user : Float?
    let id: Int
    let item: String
    var offered_price: Float?
    let user_id: Int
    
    func getType() -> TypeConfirm {
        
        if nil != offered_price, nil != confirmed_price_user, let price = confirmed_price_seller {
            return .confirmSiller(price)
        }
        
        if nil != offered_price, let price = confirmed_price_user {
            return .confirmClient(price)
        }
        
        if nil != offered_price {
            return .confirmExpert
        }
        
        return .none
    }
    
//    'confirmed_price_user': None,
//    'id': 1,
//    'item': 'Пряники',
//    'offered_price': None,
//    'user_id': 1
}

enum TypeConfirm {
    case confirmSiller(Float)
    case confirmClient(Float)
    case confirmExpert
    case none
}

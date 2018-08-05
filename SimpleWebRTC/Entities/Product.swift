//
//  Product.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

struct Product: Codable {
    
    //let confirmed_price_seller: Float?
    //let confirmed_price_user : Float?
    let id: Int
    let item: String
    //let offered_price: Float?
    let user_id: Int
    
//    'confirmed_price_user': None,
//    'id': 1,
//    'item': 'Пряники',
//    'offered_price': None,
//    'user_id': 1
}

//
//  SellerProduct.swift
//  SimpleWebRTC
//
//  Created by Evgen on 08.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation


struct SellerProduct: Codable {
    let id: Int
    let unit: String
    var offered_price: Int
    var offered_price_total: Int
    var confirmed_price_seller: Int?
    let seller_id: Int
    let confirmed_price_user: Int
    let user_id: Int
    let item: String
    let qty: Int
}

//"unit" : "шт",
//"offered_price" : 65,
//"offered_price_total" : 65,
//"id" : 44,
//"confirmed_price_seller" : null,
//"seller_id" : 16,
//"confirmed_price_user" : 65,
//"user_id" : 11,
//"item" : "gfh",
//"qty" : 1

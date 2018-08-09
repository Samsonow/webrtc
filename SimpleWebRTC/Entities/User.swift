//
//  User.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

enum TypeUser: String, Codable {

    case expert
    case seller
    case client
}

struct User: Codable {
    
    let id: Int
    let long: Double
    let balance: Int
    let address1: String?
    let city_id: Int
    let expert: Bool?
    let seller: Bool?
    let country_id: Int
    let lat: Double
    let name: String
    let address2: String?
    
    var type: TypeUser = .expert
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        long = try container.decode(Double.self, forKey: .long)
        
        
        balance = try container.decode(Int.self, forKey: .balance)
        address1 = try? container.decode(String.self, forKey: .address1)
        
        city_id = try container.decode(Int.self, forKey: .city_id)
        
        if let sellerObject = try? container.decode(Seller.self, forKey: .seller) {
            seller = true
        } else {
            seller = false
        }
        
        if let expert = try? container.decode(Expert.self, forKey: .expert) {
            type = .expert
        } else if seller == true {
            type = .seller
        } else {
            type = .client
        }

        country_id = try container.decode(Int.self, forKey: .country_id)
        lat = try container.decode(Double.self, forKey: .lat)
        name = try container.decode(String.self, forKey: .name)
        address2 = try? container.decode(String.self, forKey: .address2)
        expert = nil
    }
    
    
//    "long" : 0,
//    "balance" : 0,
//    "address1" : null,
//    "id" : 13,
//    "city_id" : 0,
//    "expert" : {
//    "lat" : 55.734499999999997,
//    "rating" : 5,
//    "reviews_count" : 0,
//    "id" : 13,
//    "image_url" : "https:\/\/alpha.tl\/nd\/moxx\/helper3.jpg",
//    "available" : true,
//    "reviews" : [
//
//    ],
//    "description" : "Описание Ромы",
//    "market_id" : 1,
//    "name" : "Рома-эксперт",
//    "long" : 37.589700000000001
//    },
//    "seller" : false,
//    "country_id" : 0,
//    "lat" : 0,
//    "name" : "Expprrtt",
//    "address2" : null
//
    
    //expert  - на страницу ожидания вызова

//    "long" : 37.719299999999997,
//    "balance" : 3000,
//    "address1" : "дл",
//    "id" : 11,
//    "city_id" : 0,
//    "expert" : false,
//    "seller" : false,
//    "country_id" : 0,
//    "lat" : 55.687199999999997,
//    "name" : "Romk",
//    "address2" : null

}

struct Seller:Codable {
    let id: Int
    //{"id": 16, "name": "SuperSeller", "description": "ahahha", "image_url": null, "market_id": 2, "available": true}
}

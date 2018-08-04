//
//  Order.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation


struct Order: Codable {
    
    let id: Int
    //let user_id: Int
    //let expert_id: Int
    let market_id: Int
    let delivery_started: String?
    let expert: Expert
    let total_cost: Float
    
    let items:[Product]
    
    
//    <Text style={[iStyle.item.date]}>{`${item.delivery_started}`}</Text>
//    <Text style={[iStyle.item.graylil]}>{`Market ID: ${item.market_id}`}</Text>
//    <Text style={[iStyle.item.graylil]}>{`Helper: ${item.expert.name}`}</Text>
//    <Text style={[iStyle.item.shoppingList]}>{`Products: ${item.items.length}`}</Text>
//    <Text style={[iStyle.item.price]}>{`${item.total_cost} rub`}</Text>
    
    
    
//    "id": 3, "user_id": 1, "expert_id": 1, "market_id": 1, "state": Channels.States.COMPLETED,
//    "lat": 111.111,
//    "long": 11.11,
//    "delivery_address": "address1, address2",
//    "delivery_lat": 56.62,
//    "delivery_long": 42.42,
//    "comment": "Комментарий пользователя или отзыв",
//    "rating": 5,
//    "items": [{
//    'confirmed_price_seller': None,
//    'confirmed_price_user': 500,
//    'id': 2,
//    'item': 'Плюшки',
//    'offered_price': 500,
//    'user_id': 1
//    }],
//    "total_cost": 500
}

//
//  Channel.swift
//  SimpleWebRTC
//
//  Created by Evgen on 05.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

enum ChannelsStates: Int, Codable {
    case REQUESTED = 1
    case REJECTED = 2
    case CANCELLED = 3
    case OPENED = 4
    case DELIVERY = 5
    case COMPLETED = 6
    case ARCHIVED = 9
}

struct Channel: Codable {
    let id: Int
    let user_id: Int
    let expert_id: Int
    let market_id: Int
    let state: ChannelsStates
    
    
   // {"result": {"id": 1, "user_id": 1, "expert_id": 1, "market_id": 1, "state": Channels.States.REQUESTED}}
}

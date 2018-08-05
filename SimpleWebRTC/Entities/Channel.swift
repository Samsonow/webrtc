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
    case REFUSED = 7
    case ARCHIVED = 9
}

struct Channel: Codable {
    let id: Int
    let user_id: Int?
    let expert_id: Int?
    let market_id: Int
    let state: ChannelsStates
    
    
   // {"result": {"id": 1, "user_id": 1, "expert_id": 1, "market_id": 1, "state": Channels.States.REQUESTED}}
}


struct ChannelGet: Codable {
    let id: Int
    let user_id: Int?
    let expert_id: Int?
    let market_id: Int
    let state: ChannelsStates
    let lat: Double
    let long: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        
        if let latContainer = try? container.decode(Double.self, forKey: .lat) {
            lat = latContainer
        } else {
            lat = 0
        }
        if let longContainer = try? container.decode(Double.self, forKey: .long) {
            long = longContainer
        } else {
            long = 0
        }
        
        user_id = try? container.decode(Int.self, forKey: .user_id)
        expert_id = try? container.decode(Int.self, forKey: .expert_id)
        
        market_id = try container.decode(Int.self, forKey: .market_id)
        
        state = try container.decode(ChannelsStates.self, forKey: .state)
        
    }
    
    init(form: Channel ) {
        self.id = form.id
        self.user_id = form.id
        self.expert_id = form.expert_id
        self.market_id = form.market_id
        self.state = form.state
        long = 0
        lat = 0
    }
    
    
    // {"result": {"id": 1, "user_id": 1, "expert_id": 1, "market_id": 1, "state": Channels.States.REQUESTED}}
}

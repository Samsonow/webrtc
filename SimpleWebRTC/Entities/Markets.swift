//
//  Markets.swift
//  SimpleWebRTC
//
//  Created by Evgen on 04.08.2018.
//  Copyright © 2018 Erdi T. All rights reserved.
//

import Foundation

struct Market: Codable {
    let available: Bool
    let id: Int
    let image_url: String
    let description: String
    let name: String
    let experts: Int
    
    
//    'available': True,
//    'city_id': 2,
//    'country_id': 1,
//    'description': 'Описание рынка 2',
//    'id': 2,
//    'image_url': 'http://image2.com',
//    'lat': 36.1245,
//    'long': 51.5428,
//    'name': 'Маркет 2',
//    'experts': 0,
//    'rating': 5,
//    'reviews_count': 0,
//    'reviews': []
    
}

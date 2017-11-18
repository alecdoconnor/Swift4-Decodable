//
//  EdamamResult.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/15/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import Foundation

struct Results: Decodable {
    
    var query: String
    var queryFrom: Int
    var queryTo: Int
    var queryIsExhaustive: Bool
    var hits: [Hit]
    
    private enum CodingKeys: String, CodingKey {
        case hits
        case query = "q"
        case queryFrom = "from"
        case queryTo = "to"
        case queryIsExhaustive = "more"
    }
    
}


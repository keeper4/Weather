//
//  LocationModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import ObjectMapper

class LocationModel: BaseModel, MappableToRealm {
    
   typealias RealmStoredObject = LocationStoredObject
    
    private(set) var name:                String!
    private(set) var country:             String!
    
    required init?(map: ObjectMapper.Map) {
        guard
            map.JSON["name"]   != nil,
            map.JSON["country"]   != nil
        else { assertionFailure(); return nil }
        
        super.init(map: map)
    }
    
    override func mapping(map: ObjectMapper.Map) {
        super.mapping(map: map)
        
        self.name                <- map["name"]
        self.country             <- map["country"]
    }
}

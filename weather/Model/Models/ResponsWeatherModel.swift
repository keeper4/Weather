//
//  ResponsWeatherModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import ObjectMapper
import Foundation

class ResponsWeatherModel: BaseModel, MappableToRealm {
    
    typealias RealmStoredObject = ResponsWeatherStoredObject
    
    private(set) var location: LocationModel!
    private(set) var current: CurrentModel!
    
    required init?(map: Map) {
        guard
            map.JSON["location"]   != nil,
            map.JSON["current"]   != nil
        else { assertionFailure(); return nil }
        
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.location <- map["location"]
        self.current  <- map["current"]
    }
}

//
//  CurrentModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import ObjectMapper

class CurrentModel: BaseModel, MappableToRealm {
    
   typealias RealmStoredObject = CurrentStoredObject
    
    private(set) var observationTime:       String!
    private(set) var temperature:           Double!
    private var weather_icons:              [String]!
    private(set) var windSpeed:             Int!
    private(set) var windDir:               String!
    private(set) var humidity:              Int!
    
    var weatherURL:          URL? {
        get {
            return URL(string: weather_icons.first ?? "")
        }
    }
    
    required init?(map: Map) {
        guard
            map.JSON["observation_time"]   != nil,
            map.JSON["temperature"]   != nil,
            map.JSON["weather_icons"]   != nil,
            map.JSON["wind_speed"]   != nil,
            map.JSON["wind_dir"]   != nil,
            map.JSON["humidity"]   != nil
        else { assertionFailure(); return nil }
        
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.observationTime         <- map["observation_time"]
        self.temperature             <- map["temperature"]
        self.weather_icons           <- map["weather_icons"]
        self.windSpeed               <- map["wind_speed"]
        self.windDir                 <- map["wind_dir"]
        self.humidity                <- map["humidity"]
    }
}

//
//  CurrentStoredObject.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CurrentStoredObject: Object, MappableToModel {
    
    typealias Model = CurrentModel
    
    @objc dynamic var observationTime:       String = ""
    @objc dynamic var temperature:           Double = 0
    @objc dynamic var windSpeed:             Int = 0
    @objc dynamic var windDir:               String = ""
    @objc dynamic var humidity:              Int = 0
    
    var weather_icons: [String] {
        get { return self.privateWeather_icons.map { $0 } }
        set { self.privateWeather_icons.append(objectsIn: newValue) }
    }
        
    private dynamic var privateWeather_icons: List<String> = List<String>()
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: ObjectMapper.Map) {
        if map.mappingType == .toJSON {
            self.observationTime  >>> map["observation_time"]
            self.temperature      >>> map["temperature"]
            self.weather_icons    >>> map["weather_icons"]
            self.windSpeed        >>> map["wind_speed"]
            self.windDir          >>> map["wind_dir"]
            self.humidity         >>> map["humidity"]
        } else {
            self.observationTime  <- map["observation_time"]
            self.temperature      <- map["temperature"]
            self.weather_icons    <- map["weather_icons"]
            self.windSpeed        <- map["wind_speed"]
            self.windDir          <- map["wind_dir"]
            self.humidity         <- map["humidity"]
        }
    }
}

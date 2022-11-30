//
//  ResponsWeatherStoredObject.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class ResponsWeatherStoredObject: Object, MappableToModel {
    typealias Model = ResponsWeatherModel

    @objc dynamic var location: LocationStoredObject!
    @objc dynamic var current: CurrentStoredObject!

    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }

    func mapping(map: ObjectMapper.Map) {
        if map.mappingType == .toJSON {
            self.location           >>> map["location"]
            self.current            >>> map["current"]
        } else {
            self.location           <- map["location"]
            self.current            <- map["current"]
        }
    }
}

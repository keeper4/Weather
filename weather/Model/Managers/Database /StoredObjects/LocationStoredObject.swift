//
//  LocationStoredObject.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class LocationStoredObject: Object, MappableToModel {

    typealias Model = LocationModel

    @objc dynamic var name      : String = ""
    @objc dynamic var country   : String = ""

    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }

    func mapping(map: ObjectMapper.Map) {
        if map.mappingType == .toJSON {
            self.name           >>> map["name"]
            self.country        >>> map["country"]
        } else {
            self.name           <- map["name"]
            self.country        <- map["country"]
        }
    }
}

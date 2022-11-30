//
//  BaseIdModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper

class BaseIdModel: BaseModel {

    internal var id: Int = 0

    internal override init() {
        super.init()
    }

    required init?(map: Map) {
        guard
            map.JSON["id"] != nil
            else { return nil }

        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        self.id <- map["id"]
    }
}

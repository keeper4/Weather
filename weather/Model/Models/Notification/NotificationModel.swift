//
//  NotificationModel.swift
//  digitalmedia
//
//  Created by Oleksandr Chyzh on 01.04.2020.
//  Copyright © 2020 Oolla. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationModel: BaseModel {
    
    private(set) var type: PushType?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.type      <- (map["type"], PushType.transformer)
    }
}

enum PushType: String {
    case Note, GeoLocation, Mood, Photo, Handoff
    
    static var transformer: TransformOf<PushType, String> {
        return TransformOf<PushType, String>(fromJSON: {
            PushType(rawValue: $0 ?? "")
        }, toJSON: {
            $0.map { String($0.rawValue) }
        })
    }
    
    var description: String {
        return self.rawValue
    }
}

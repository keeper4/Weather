//
//  AccessInfoModel.swift
//  digitalmedia
//
//  Created by Samatbek on 3/4/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import Foundation
import ObjectMapper

class AccessInfoModel: BaseModel, MappableToRealm {
    
    private let expiresSoonTimeInterval: TimeInterval = 20.0
    
    typealias RealmStoredObject = AccessInfoStoredObject
    
    private(set) var key:               String = ""
    private(set) var refreshToken:      String = ""
    private(set) var expirationDate:    Date = Date().currentUTCTimeZoneDate
    private(set) var expires_in: Int!
    
    init(token: String, expirationDate: Date, refreshToken: String) {
        self.key = token
        self.expirationDate = expirationDate
        self.refreshToken = refreshToken
        
        let components = Calendar.current.dateComponents([.second],
                                                         from: Date().currentUTCTimeZoneDate,
                                                         to: expirationDate)
        self.expires_in = components.second
        super.init()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        self.key            <- map["key"]
        if key.isEmpty {
            self.key <- map["access_token"]
        }
        
        self.expires_in     <- map["expires_in"]
        self.refreshToken   <- map["refresh_token"]
        
        if map.toObject {
            self.expirationDate <- (map["expirationDate"], DateFormatter.baseTrasformer)
        } else {
            self.expirationDate = Date().add(seconds: self.expires_in) ?? Date()
        }
    }
    
    func secondsUntileExpired() -> Int {
        return Int(self.expirationDate - Date().currentUTCTimeZoneDate)
    }

    var justUpdated: Bool {
        return self.expirationDate > Date().currentUTCTimeZoneDate.add(seconds: self.expires_in - 20)!
    }
}

extension Date {

  var currentUTCTimeZoneDate: Date {
       let formatter = DateFormatter()
       formatter.timeZone = TimeZone(identifier: "UTC")
       return self
   }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}

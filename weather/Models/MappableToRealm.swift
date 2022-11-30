//
//  MappableToRealm.swift
//  digitalmedia
//
//  Created by Rasul on 13/12/18.
//  Copyright © 2018 Zensoft. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

protocol MappableToRealm: BaseMappable {
    
    associatedtype RealmStoredObject: Object & Mappable
}

extension MappableToRealm where Self: BaseMappable {
    
    func toRealmStoredObject() -> RealmStoredObject {
        let json = self.toJSON()
        return RealmStoredObject(JSON: json)!
    }
}

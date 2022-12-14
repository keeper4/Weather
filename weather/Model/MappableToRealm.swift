//
//  MappableToRealm.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
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
    
    func save(realm: Realm) {
        realm.add(toRealmStoredObject(),
                  update: RealmStoredObject.primaryKey() != nil ? .all : .error)
    }
}

//
//  DatabaseMigrator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseMigrator {
    
    static let schemaVersion: UInt64 = 1
    
    static var realm: Realm = {
        let configuration = Realm.Configuration(schemaVersion: DatabaseMigrator.schemaVersion,
                                                migrationBlock: { _, _ in })
        Realm.Configuration.defaultConfiguration = configuration
        
        guard let realm = try? Realm() else { fatalError("cannot initialize realm") }
        
        return realm
    }()
}

//
//  DatabaseManager.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa

class DatabaseManager: BaseDataManager, DatabaseAPI, BaseModelMappingContext {
    
    let realm: Realm
    
    init(baseModelStorage: BaseModelStorage, realm: Realm) {
        self.realm = realm
        
        super.init(baseModelStorage: baseModelStorage)
    }
    
    // MARK: - DatabaseAPI
   
}

extension DatabaseManager {
    
    func save<T: MappableToRealm>(_ model: T) {
        try? self.realm.writeOpeningTransactionIfNeeded { [weak self] in
            guard let self = self else { return }
            model.save(realm: self.realm)
//            guard let self = self else { return }
//
//            switch model {
//
//            case is ResponsWeatherModel:
//
//                self.realm.add(model.toRealmStoredObject(),
//                               update: ResponsWeatherStoredObject.primaryKey() != nil ? .all : .error)
//
//            default: fatalError("DatabaseManager save default no logic")
//            }
        }
    }
    
    func loadCurrentWeather(city: String) -> Observable<ResponsWeatherModel?> {
        let objs = self.realm.objects(ResponsWeatherStoredObject.self)
            .filter { $0.location.name == city }
            .first
            .map { ($0.toModel(self)! )}
        
        return Observable.just(objs)
    }
}

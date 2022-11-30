//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper
import RxSwift

class UserDefaultsManager: UserDefaultsAPI {
    private enum Keys: String {
        case key
    }
    
    private var userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }

}

extension UserDefaultsManager {
    private func getModel<Model: BaseModel>(key: Keys) -> Model? {
        guard let jsonString = self.userDefaults.string(forKey: key.rawValue) else {
            return nil
        }
        guard let json = jsonString.toJson() else {
            return nil
        }
        let model = Mapper<Model>().map(JSON: json)
        return model
    }
    
    private func setModel<Model: BaseModel>(key: Keys, model: Model?) {
        if let json = model?.toJSONString() {
            self.userDefaults.set(json, forKey: key.rawValue)
        } else {
            self.userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}

//
//  ApiContainer.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

struct ApiContainer: ServiceAPIContainer {
    let httpRequestAPI: HTTPRequestAPI
    let databaseAPI: DatabaseAPI
    let userDefaultsAPI: UserDefaultsAPI
    
    static var shared: ApiContainer = {
        let baseModelStorage = BaseModelStorage()
        
        let databaseManager = DatabaseManager(baseModelStorage: baseModelStorage, realm: DatabaseMigrator.realm)
        
        let userDefaultsManager = UserDefaultsManager()
        
        guard let httpRequestManager = try? HTTPRequestManager(baseModelStorage: baseModelStorage,
                                                               baseUrlString: Constants.baseUrl)
            else { fatalError("cannot initialize httpRequestManager") }
  

        let apiContainer = ApiContainer(httpRequestAPI: httpRequestManager,
                                        databaseAPI: databaseManager,
                                        userDefaultsAPI: userDefaultsManager)
        
        return apiContainer
    }()
    
    private init(httpRequestAPI: HTTPRequestAPI, databaseAPI: DatabaseAPI, userDefaultsAPI: UserDefaultsAPI) {
        self.httpRequestAPI = httpRequestAPI
        self.databaseAPI = databaseAPI
        self.userDefaultsAPI = userDefaultsAPI
    }
}

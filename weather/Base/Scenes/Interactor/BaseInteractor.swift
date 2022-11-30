//
//  BaseInteractor.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift

class BaseInteractor: BaseService {

    let httpRequestAPI:     HTTPRequestAPI
    let databaseAPI:        DatabaseAPI
    let userDefaultsAPI:    UserDefaultsAPI
    
    let disposeBag = DisposeBag()
    
    required init(apiContainer: ServiceAPIContainer) {
        self.httpRequestAPI     = apiContainer.httpRequestAPI
        self.databaseAPI        = apiContainer.databaseAPI
        self.userDefaultsAPI    = apiContainer.userDefaultsAPI
    }
}

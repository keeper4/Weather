//
//  BaseDataManager.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

class BaseDataManager {
    
    let baseModelStorage: BaseModelStorage
    
    init(baseModelStorage: BaseModelStorage) {
        self.baseModelStorage = baseModelStorage
    }
}

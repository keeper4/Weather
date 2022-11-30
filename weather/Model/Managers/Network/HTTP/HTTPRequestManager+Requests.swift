//
//  HTTPRequestManager+Requests.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import UIKit

extension HTTPRequestManager {
    
    struct Endpoint {
        
        static let current                = "current"

        private init() {}
    }
}

extension HTTPRequestManager {
    
    struct CurrentWeatherRequest: HTTPRequest {
        let method: HTTPRequestMethod = .GET
        var path: String = Endpoint.current
        var parameters: [String : Any]? = nil
        
        init(city: String) {
            self.parameters = ["access_key" : Constants.weatherApiKey,
                               "query" : city]
        }
    }
}

//
//  HTTPRequestManager+HTTPRequestAPI.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift

extension HTTPRequestManager: HTTPRequestAPI {
    
    func getCurrentWeather(city: String) -> Observable<ResponsWeatherModel> {
        let request = CurrentWeatherRequest(city: city)
        return self.makeRequest(request)
    }
}

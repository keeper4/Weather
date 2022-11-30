//
//  API.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

enum NetworkError: Error, Equatable {
    
    case notFound
    case invalidAccessKey
    case inactive_user
    case invalid_api_function
    case usage_limit_reached
    
    case unknown
    case timeOut
    case noConnection
    case noResponse
    
    case other(message: String)
    case cantParseModel
    case emptyContant
    case badRequest
    case internalServerError
    case serverCantParseData
    case invalidUrl
    
    var caseName: String {
        return Mirror(reflecting: self).children.first?.label ?? String(describing: self)
    }
}

protocol API: AnyObject {}

protocol AccessInfoRequiringAPI: API {
    
}

protocol HTTPRequestAPI: AccessInfoRequiringAPI {
    func getCurrentWeather(city: String) -> Observable<ResponsWeatherModel>
}

protocol DatabaseAPI: API {
    
    func save<T: MappableToRealm>(_ model: T)
    func loadCurrentWeather(city: String) -> Observable<ResponsWeatherModel?>
}

protocol UserDefaultsAPI: API {
    
}

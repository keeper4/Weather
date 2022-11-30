//
//  DetailInteractor.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift

class DetailInteractor: BaseInteractor, DetailService {

    // MARK: DetailService
    
    func getCurrentWeather(city: String) -> Observable<ResponsWeatherModel> {
        return self.httpRequestAPI.getCurrentWeather(city: city)
            .doOnNext { [weak self] in self?.databaseAPI.save($0) }
    }
    
    func loadCurrentWeather(city: String) -> Observable<ResponsWeatherModel?> {
        return self.databaseAPI.loadCurrentWeather(city: city)
    }
}

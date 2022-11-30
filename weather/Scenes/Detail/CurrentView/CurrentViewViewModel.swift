//
//  CurrentViewViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 30.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrentViewViewModel: BaseViewViewModel, CurrentViewDatasource {
    
    // MARK: CurrentViewDatasource
        
    private(set) lazy var time: Driver<String> = self._time.asDriver(onErrorJustReturn: "")
    private(set) lazy var temperature: Driver<String> = self._temperature
        .map { NSLocalizedString("CurrentViewViewModel.temperature") + "\n\($0)" }
        .asDriver(onErrorJustReturn: "")
    private(set) lazy var weatherURL: Driver<URL?> = self._weatherURL.asDriver(onErrorJustReturn: nil)
    private(set) lazy var windSpeed: Driver<String> = self._windSpeed
        .map { NSLocalizedString("CurrentViewViewModel.windSpeed") + "\n\($0)" }
        .asDriver(onErrorJustReturn: "")
    private(set) lazy var windDir: Driver<String> = self._windDir
        .map { NSLocalizedString("CurrentViewViewModel.windDir") + "\n\($0)" }
        .asDriver(onErrorJustReturn: "")
    private(set) lazy var humidity: Driver<String> = self._humidity
        .map { NSLocalizedString("CurrentViewViewModel.humidity") + "\n\($0)" }
        .asDriver(onErrorJustReturn: "")
    
    // MARK: - private
    
    private let _time = BehaviorSubject<String>(value: "")
    private let _temperature  = BehaviorSubject<Double>(value: 0)
    private let _weatherURL  = BehaviorSubject<URL?>(value: nil)
    private let _windSpeed  = BehaviorSubject<Int>(value: 0)
    private let _windDir  = BehaviorSubject<String>(value: "")
    private let _humidity  = BehaviorSubject<Int>(value: 0)
    
    // MARK: - public
    
    private(set) lazy var onTime: AnyObserver<String> = self._time.asObserver()
    private(set) lazy var onTemperature: AnyObserver<Double> = self._temperature.asObserver()
    private(set) lazy var onWeatherURL: AnyObserver<URL?> = self._weatherURL.asObserver()
    private(set) lazy var onWindSpeed: AnyObserver<Int> = self._windSpeed.asObserver()
    private(set) lazy var onWindDir: AnyObserver<String> = self._windDir.asObserver()
    private(set) lazy var onHumidity: AnyObserver<Int> = self._humidity.asObserver()
}

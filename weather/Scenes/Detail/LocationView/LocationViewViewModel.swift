//
//  LocationViewViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 30.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LocationViewViewModel: BaseViewViewModel, LocationViewDatasource {

    // MARK: SearchBarViewDatasource
    
    private(set) lazy var city: Driver<String> = self._city.asDriver(onErrorJustReturn: "")
    private(set) lazy var country: Driver<String> = self._country.asDriver(onErrorJustReturn: "")
    
    // MARK: - private
    
    private let _city  = BehaviorSubject<String>(value: "")
    private let _country  = BehaviorSubject<String>(value: "")
    
    
    // MARK: - public
    private(set) lazy var onCity: AnyObserver<String> = self._city.asObserver()
    private(set) lazy var onCountry: AnyObserver<String> = self._country.asObserver()
}

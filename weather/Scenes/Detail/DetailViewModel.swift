//
//  DetailViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift

struct DetailParameters {
    let city: String
}

protocol DetailService: BaseService {
    func loadCurrentWeather(city: String) -> Observable<ResponsWeatherModel?>
    func getCurrentWeather(city: String) -> Observable<ResponsWeatherModel>
}

class DetailViewModel: BaseViewControllerViewModel<DetailParameters>, DetailDatasource {
    
    // MARK: - DetailDatasource
    
    private(set) lazy var currentViewDatasource: CurrentViewDatasource = self.currentVM
    private(set) lazy var locationViewDatasource: LocationViewDatasource = self.locationVM
    
    
    private let currentVM = CurrentViewViewModel()
    private let locationVM = LocationViewViewModel()
    
    private let city: String
    required init(parameters: DetailParameters, service: BaseService) {
        self.city = parameters.city
        super.init(parameters: parameters, service: service)
        self.setTitle?.onNext(parameters.city)
    }
    
    override func setupViewModelToServiceBindings(_ service: BaseService, disposeBag: DisposeBag) {
        super.setupViewModelToServiceBindings(service, disposeBag: disposeBag)
        
        guard let service = service as? DetailService else { return }
        
        self.onViewDidLoad
            .flatMapLatest { [unowned service, unowned self] _ -> Observable<ResponsWeatherModel?> in
                return service.loadCurrentWeather(city: self.city)
            }
            .doOnNext { [weak self] in self?.setupUI($0) }
            .flatMapLatest { [unowned service, unowned self] _ -> Observable<ResponsWeatherModel> in
                return service.getCurrentWeather(city: self.city)
                    .doOnNextAndOnError { GIFHUD.dismiss() }
                    .retry(when:self.makeRetryAlertHandler(actionBeforeRetrying: { GIFHUD.show() }))
            }
            .bind(to: Binder(self) { target, model in
                target.setupUI(model)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupUI(_ model: ResponsWeatherModel?) {
        
        guard let model = model else { return }
        
        self.currentVM.onTime.onNext(model.current.observationTime)
        self.currentVM.onTemperature.onNext(model.current.temperature)
        self.currentVM.onWeatherURL.onNext(model.current.weatherURL)
        self.currentVM.onWindSpeed.onNext(model.current.windSpeed)
        self.currentVM.onWindDir.onNext(model.current.windDir)
        self.currentVM.onHumidity.onNext(model.current.humidity)
        
        self.locationVM.onCity.onNext(model.location.name)
        self.locationVM.onCountry.onNext(model.location.country)
    }
}

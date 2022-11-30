//
//  SearchViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift

class SearchViewModel: BaseViewControllerViewModel<Void>, SearchDatasource {
    
    private(set) var tabTitle   = ""
    private(set) var tabIcon    = ""
    
    // MARK: - SearchDatasource
    
    private(set) lazy var citiesTableViewDatasource: MyTableViewDatasource = self.citiesTableViewVM
    
    private let citiesTableViewVM = MyTableViewVM()
    
    private let _tapCity = PublishSubject<String>()
    
    private(set) lazy var onTapCity: Observable<String> = self._tapCity.share()
    
    required init(parameters: Void, service: BaseService) {
        super.init(parameters: parameters, service: service)
        self.setTitle?.onNext(NSLocalizedString("SearchViewModel.Search"))
        
        self.onViewDidLoad
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: Binder(self) { target, _ in
                target.setupTVSections()
            })
            .disposed(by: disposeBag)
        
        self.citiesTableViewVM.onSelectDS
            .filter { ($0 as? CityTVCellDatasource) != nil }
            .map { $0 as! CityTVCellDatasource }
            .map { $0.name }
            .bind(to: self._tapCity)
            .disposed(by: self.disposeBag)
    }
    
    private func setupTVSections() {

        let vm = [
            CityTVCellVM(cityName: "Rome"),
            CityTVCellVM(cityName: "New York"),
            CityTVCellVM(cityName: "london"),
            CityTVCellVM(cityName: "Paris")
        ]
        
        self.citiesTableViewVM.onSections.onNext([ViewDatasourceSection(model: nil, items: vm)])
    }
}


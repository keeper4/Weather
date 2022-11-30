//
//  LocationView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 30.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol LocationViewDatasource: ViewDatasource {
    var city: Driver<String> { get }
    var country: Driver<String> { get }
}

class LocationView: WrapperView {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? LocationViewDatasource else { return }

        datasource.city
            .drive(self.cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.country
            .drive(self.countryLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

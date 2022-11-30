//
//  CurrentView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 30.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol CurrentViewDatasource: ViewDatasource {
    var time: Driver<String> { get }
    var temperature: Driver<String> { get }
    var weatherURL: Driver<URL?> { get }
    var windSpeed: Driver<String> { get }
    var windDir: Driver<String> { get }
    var humidity: Driver<String> { get }
}

class CurrentView: WrapperView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? CurrentViewDatasource else { return }

        datasource.time
            .drive(self.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.temperature
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.windSpeed
            .drive(self.windSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.windDir
            .drive(self.windDirLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.humidity
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        datasource.weatherURL
            .drive(self.weatherUrlBinder)
            .disposed(by: disposeBag)
    }
    
    private lazy var weatherUrlBinder = Binder<URL?>(self) { target, url in
        target.weatherImageView.kf.setImageWithImageSize(with: url,
                                                         imageSize: target.weatherImageView.frame.size)
    }
}

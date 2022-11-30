//
//  CityTVCellVM.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

class CityTVCellVM: BaseViewViewModel, CityTVCellDatasource {
    
    //CityTVCellDatasource
    
    var name: String
    
    init(cityName: String) {
        self.name = cityName
    }
}

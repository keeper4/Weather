//
//  View.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

protocol ViewDatasource: AnyObject {}

protocol View {
    
    var datasource: ViewDatasource! { get set }
}

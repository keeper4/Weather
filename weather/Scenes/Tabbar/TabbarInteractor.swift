//
//  TabbarInteractor.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TabbarInteractor: BaseInteractor, TabbarService {
    
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

//
//  ViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import RxSwift

class ViewModel {
    
    var disposeBag = DisposeBag()
    
    func dispose() {
        self.disposeBag = DisposeBag()
    }
    
    deinit {
        self.dispose()
    }
}

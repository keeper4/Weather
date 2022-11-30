//
//  BaseViewViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class BaseViewViewModel: ViewModel, ViewDatasource {}

class BaseViewViewModelWithService: BaseViewViewModel {
    final var service: BaseService {
        get {
            return self._service
        }
        set {
            self._service = newValue
            let serviceDisposeBag = DisposeBag()
            self.setupViewModelToServiceBindings(newValue, disposeBag: serviceDisposeBag)
            self.serviceDisposeBag = serviceDisposeBag
        }
    }
    private var _service: BaseService!
    private var serviceDisposeBag: DisposeBag?
    
    func setupViewModelToServiceBindings(_ service: BaseService, disposeBag: DisposeBag) {}
    
    override func dispose() {
        super.dispose()
        self.serviceDisposeBag = nil
    }
}

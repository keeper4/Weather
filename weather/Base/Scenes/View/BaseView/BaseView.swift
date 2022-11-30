//
//  BaseView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseView: UIView, View {
    
    let disposeBag = DisposeBag()
    
    var datasourceBinder: Binder<ViewDatasource> {
        return Binder(self) { target, datasource in
            target.datasource = datasource
        }
    }
    
    final var datasource: ViewDatasource! {
        get {
            return self._datasource
        }
        set {
            self._datasource = newValue
            let datasourceDisposeBag = DisposeBag()
            self.setupInterfaceToDatasourceBindings(newValue, disposeBag: datasourceDisposeBag)
            self.datasourceDisposeBag = datasourceDisposeBag
        }
    }
    private var _datasource: ViewDatasource!
    private var datasourceDisposeBag: DisposeBag?
    
    func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {}
    
    func prepareForReuse() {
        self.datasourceDisposeBag = DisposeBag()
    }
}

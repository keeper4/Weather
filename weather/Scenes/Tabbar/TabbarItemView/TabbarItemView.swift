//
//  TabbarItemView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol TabbarItemViewDatasource: ViewDatasource {

    var tabbarItemImage:            String              { get }
    var isItemDisable:              Bool                { get }
    var isTabbarItemSelected:       Observable<Bool>    { get }
    var tapItem:                    AnyObserver<Void>   { get }
    var tabElementType:             TabElementType      { get }
}

class TabbarItemView: WrapperView {

    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? TabbarItemViewDatasource else { return }
    }
}

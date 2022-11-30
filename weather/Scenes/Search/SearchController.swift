//
//  SearchController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

protocol SearchDatasource: ViewDatasource {
    var citiesTableViewDatasource: MyTableViewDatasource { get }
}

class SearchController: BaseViewController {
    
    @IBOutlet private weak var citiesTableView: MyTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientLayer()
    }
    
    override func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource,
                                                     disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? SearchDatasource else { return }
        
        self.citiesTableView.datasource = datasource.citiesTableViewDatasource
    }
}

//
//  DetailController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

protocol DetailDatasource: ViewDatasource {
    var currentViewDatasource: CurrentViewDatasource { get }
    var locationViewDatasource: LocationViewDatasource { get }
}

class DetailController: BaseViewController {
    
    @IBOutlet private weak var currentView: CurrentView!
    @IBOutlet private weak var locationView: LocationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientLayer()
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem
    }
    
    override func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource,
                                                     disposeBag: DisposeBag) {
        guard let datasource = datasource as? DetailDatasource else { return }
     
        self.currentView.datasource  = datasource.currentViewDatasource
        self.locationView.datasource = datasource.locationViewDatasource
    }
}

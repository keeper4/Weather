//
//  OrderEmptyView.swift
//  digitalmedia
//
//  Created by Oleksandr Chyzh on 14.07.2020.
//  Copyright © 2020 Oolla. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol EmptyTVDataViewDatasource: ViewDatasource {
    var titleText: Driver<String>         { get }
    var image: String                     { get }
}

class EmptyTVDataView: WrapperView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var image: UIImageView!
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        guard let datasource = datasource as? EmptyTVDataViewDatasource else { return }
        
        datasource.titleText
            .drive(self.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
       // self.image.image = UIImage(named: datasource.image)
    }
}

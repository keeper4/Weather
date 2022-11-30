//
//  BaseCollectionViewCell.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell, View {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.datasourceDisposeBag = DisposeBag()
    }
}

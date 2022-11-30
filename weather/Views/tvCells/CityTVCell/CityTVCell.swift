//
//  CityTVCell.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

protocol CityTVCellDatasource: ViewDatasource {
    var name: String { get }
}

class CityTVCell: BaseTableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel! {
        didSet {
            self.nameLabel.text = "  "
        }
    }
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = datasource as? CityTVCellDatasource else { return }
        
        self.nameLabel.text                = datasource.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }
}

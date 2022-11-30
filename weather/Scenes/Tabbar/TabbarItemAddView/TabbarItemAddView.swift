//
//  TabbarItemView.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 4/3/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit
import RxSwift

class TabbarItemAddView: WrapperView {

    @IBOutlet private weak var tabbarItemImageView:     UIImageView!
    @IBOutlet private weak var tabbarButton:            UIButton!
    
    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)

        guard let datasource = datasource as? TabbarItemViewDatasource else { return }

//        self.tabbarItemImageView.image  = UIImage(named: datasource.tabbarItemImage)
//
//        self.tabbarButton.rx.tap
//            .bind(to: datasource.tapItem)
//            .disposed(by: disposeBag)
    }
}

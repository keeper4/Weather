//
//  ActionSheetActionView.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import UIKit
protocol ActionSheetActionViewDatasource: ViewDatasource {

    var title:  String              { get }
    var color:  UIColor             { get }
    var tap:    AnyObserver<Void>   { get }
}

class ActionSheetActionView: WrapperView {

    @IBOutlet private weak var titleLabel: UILabel!

    private let tapGestureRecognizer = UITapGestureRecognizer()

    override func commonInit() {
        super.commonInit()

        self.xibLoadedContentView.addGestureRecognizer(self.tapGestureRecognizer)
    }

    override func setupInterfaceToDatasourceBindings(_ datasource: ViewDatasource, disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)

        if let datasource = datasource as? ActionSheetActionViewDatasource {
            self.titleLabel.text = datasource.title
            self.titleLabel.textColor = datasource.color

            self.tapGestureRecognizer.rx.event
                .filter { $0.state == .ended }
                .map { _ in }
                .bind(to: datasource.tap)
                .disposed(by: disposeBag)
        }
    }
}


//
//  ActionSheetViewController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol ActionSheetDatasource: BaseViewControllerDatasource {

    var actionSheetTitle:   String { get }
    var actionSheetMessage: String { get }
    var actionSheetImage: String? { get }

    var cancelsOnTapOutside: Bool { get }

    var actions:            Observable<[ActionSheetActionViewDatasource]> { get }
}

class ActionSheetViewController: BaseViewController {

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var stackView:           UIStackView!
    @IBOutlet private weak var titleLabel:          UILabel!
    @IBOutlet private weak var messageLabel:        UILabel!
    @IBOutlet private weak var cancelButton:        UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.presentingViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    var backgroundImage: UIImage? {
        didSet {
            self.backgroundImageView.image = self.backgroundImage
        }
    }

    private var actionViews = [ActionSheetActionView]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            self.actionViews.forEach { self.stackView.addArrangedSubview($0) }
        }
    }

    override func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource,
                                                     disposeBag: DisposeBag)
    {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)

        if let datasource = datasource as? ActionSheetDatasource {
            self.titleLabel.text = datasource.actionSheetTitle
            self.messageLabel.text = datasource.actionSheetMessage
            self.cancelButton.isEnabled = datasource.cancelsOnTapOutside

            datasource.actions
                .bind(to: self.actions)
                .disposed(by: disposeBag)

            self.cancelButton.rx.tap
                .bind(to: datasource.didCancel)
                .disposed(by: disposeBag)
        }
    }

    private var actions: Binder<[ActionSheetActionViewDatasource]> {
        return Binder(self) { target, actions in
            target.actionViews = actions.map { datasource -> ActionSheetActionView in
                let view = ActionSheetActionView()
                view.datasource = datasource
                return view
            }
        }
    }
}


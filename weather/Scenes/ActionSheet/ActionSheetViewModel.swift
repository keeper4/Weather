//
//  ActionSheetViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import UIKit

struct ActionSheetParameters {

    struct Action {
        let title: String
        let color: UIColor
        let action: () -> Any?
    }

    let title: String
    let message: String
    var image: String?

    var actions: [Action]

    let cancelsOnTapOutside: Bool
}

class ActionSheetViewModel: BaseViewControllerViewModel<ActionSheetParameters>, ActionSheetDatasource {

    // MARK: ActionSheetDatasource
    let actionSheetTitle: String

    let actionSheetMessage: String

    let cancelsOnTapOutside: Bool

    let actionSheetImage: String?
    
    private(set) lazy var actions = Observable<[ActionSheetActionViewDatasource]>
        .create { [unowned self] observer in
            observer.onNext(self.actionViewModels)
            return Disposables.create()
        }
        .share(replay: 1)

    // MARK: - public
    private(set) lazy var onCompleted = self._onCompleted
        .take(1)
        .share()

    // MARK: - private
    private var actionViewModels = [ActionSheetActionViewModel]()
    private let _onCompleted = PublishSubject<Any?>()

    required init(parameters: ActionSheetParameters, service: BaseService) {
        self.actionSheetTitle = parameters.title
        self.actionSheetMessage = parameters.message
        self.cancelsOnTapOutside = parameters.cancelsOnTapOutside
        self.actionSheetImage = parameters.image
        
        super.init(parameters: parameters, service: service)

        self.actionViewModels = parameters.actions.map { [unowned self] action -> ActionSheetActionViewModel in
            let viewModel = ActionSheetActionViewModel(title: action.title, color: action.color)
            viewModel.onTap
                .map { action.action() }
                .bind(to: self._onCompleted)
                .disposed(by: self.disposeBag)
            return viewModel
        }
    }
}


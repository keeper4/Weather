//
//  ActionSheetCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import UIKit
enum ActionSheetCompletionResult {
    case choosedAnAction(result: Any?)
    case cancelled
}

class ActionSheetCoordinator: BaseCoordinator
    <ActionSheetCompletionResult,
    BaseInteractor,
    ActionSheetParameters,
    ActionSheetViewModel,
    ActionSheetViewController>
{
    private var presentingViewController: UIViewController?
    private let transitioner = FadeViewControllerTransitioner()

    init(presentingViewController: UIViewController,
         parameters: ActionSheetParameters,
         serviceAPIContainer: ServiceAPIContainer)
    {
        self.presentingViewController = presentingViewController

        super.init(parameters: parameters, serviceAPIContainer: serviceAPIContainer)
    }

    override func start(animated: Bool) -> Observable<ActionSheetCompletionResult> {
        _ = super.start(animated: animated)

        guard
            let viewModel = self.viewModel,
            let viewController = self.viewController
            else { fatalError("cannot find view model or view controller") }

        viewController.transitioningDelegate = self.transitioner

        self.presentingViewController?.present(viewController, animated: animated)

        let cancelled = viewModel.onDidCancel
            .map { ActionSheetCompletionResult.cancelled }
        let completed = viewModel.onCompleted
            .map { ActionSheetCompletionResult.choosedAnAction(result: $0) }

        return Observable.merge(cancelled, completed)
            .do(onNext: { [weak self] _ in self?.presentingViewController?.dismiss(animated: true) })
            .take(1)
    }
}


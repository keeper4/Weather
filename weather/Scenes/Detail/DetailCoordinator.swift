//
//  DetailCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

class DetailCoordinator: BaseCoordinator
<Void,
 DetailInteractor,
 DetailParameters,
 DetailViewModel,
 DetailController> {
     
     private let navigationController: BaseNavigationController
     private let previousVC: UIViewController?
     
     init(navigationController: BaseNavigationController,
          parameters: DetailParameters,
          serviceAPIContainer: ServiceAPIContainer) {
         
         self.navigationController = navigationController
         self.previousVC = self.navigationController.viewControllers.last
         super.init(parameters: parameters, serviceAPIContainer: serviceAPIContainer)
     }
     
     override func start(animated: Bool) -> Observable<Void> {
         _ = super.start(animated: animated)
         
         guard
            let viewModel = self.viewModel,
            let viewController = self.viewController
         else { fatalError("cannot find view model or view controller") }
         
         self.navigationController.pushViewController(viewController, animated: true)
         
         self.navigationController.onPopViewController
             .filter { [unowned viewController] in $0 === viewController }
             .map { _ in }
             .bind(to: viewModel.didCancel)
             .disposed(by: self.disposeBag)
         
         return viewModel.onDidCancel
             .do(onNext: { [weak self] in
                 if let previousVC = self?.previousVC {
                     self?.navigationController.popToViewController(previousVC, animated: true)
                 } else {
                     self?.navigationController.popViewController(animated: true)
                 }
             })
             .take(1)
     }
 }

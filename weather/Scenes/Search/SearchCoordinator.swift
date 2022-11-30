//
//  SearchCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

class SearchCoordinator: BaseCoordinator
<Void,
 BaseInteractor,
 Void,
 SearchViewModel,
 SearchController>, TabElement {
     
     var tabIcon: String {
         if let viewModel = self.viewModel {
             return viewModel.tabIcon
         }
         return ""
     }
     
     var itemEnable: Bool = true
     
     var tabViewController: UINavigationController? {
         return self.navigationController
     }
     
     var tabElementType: TabElementType = .search
     
     private var navigationController: BaseNavigationController
     
     init(serviceAPIContainer: ServiceAPIContainer) {
         self.navigationController = UINavigationController.searchNavigationController()
         
         super.init(parameters: (), serviceAPIContainer: serviceAPIContainer)
     }
     
     override func start(animated: Bool) -> Observable<Void> {
         _ = super.start(animated: animated)
         
         guard let viewModel = self.viewModel, let viewController = self.viewController
         else { fatalError("no view model or view controller found") }
         
         self.navigationController.viewControllers = [viewController]
         
         viewModel.onTapCity
             .flatMapLatest { [unowned self, unowned navigationController] city in
                 self.showDetail(navigationController: navigationController, city: city)
             }
             .subscribe()
             .disposed(by: disposeBag)
         
         return viewModel.onDidCancel
             .take(1)
     }
     
     private func showDetail(navigationController: BaseNavigationController, city: String) -> Observable<Void> {
         
         let coordinator = DetailCoordinator(navigationController: navigationController,
                                             parameters: .init(city: city),
                                             serviceAPIContainer: self.serviceAPIContainer)
         
         return self.coordinate(to: coordinator, animated: true)
     }
 }

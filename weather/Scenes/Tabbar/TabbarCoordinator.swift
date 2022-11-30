//
//  TabbarCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import SafariServices
import RxSwift

class TabbarCoordinator: BaseCoordinator
<Void,
 TabbarInteractor,
 TabbarParameters,
 TabbarViewModel,
 TabbarViewController> {
     
     private var tabElements: [TabElement] = []
     private var window: UIWindow
     
     private var searchCoordinator: SearchCoordinator
     
     init(window: UIWindow, parameters: TabbarParameters, serviceAPIContainer: ServiceAPIContainer) {
         self.window = window
         self.searchCoordinator = SearchCoordinator(serviceAPIContainer: serviceAPIContainer)
         super.init(parameters: parameters, serviceAPIContainer: serviceAPIContainer)
     }
     
     override func start(animated: Bool) -> Observable<Void> {
         _ = super.start(animated: animated)
         
         guard
            let viewModel = self.viewModel,
            let viewController = self.viewController
         else { fatalError("viewModel or viewController can't find") }
         
         self.window.rootViewController = viewController
         self.window.makeKeyAndVisible()
         
         viewModel.onNeedShowTabElement
             .bind { [unowned self] in
                 self.showTabElement($0)
             }
             .disposed(by: self.disposeBag)
         
         viewModel.onNeedsPopToRoot
             .bind { [unowned self] in
                 self.popToRoot($0)
             }
             .disposed(by: self.disposeBag)
         
         self.coordinate(to: self.searchCoordinator, animated: false)
             .subscribe()
             .disposed(by: self.disposeBag)
         
         viewModel.onLoggedInAsMain
             .bind { [unowned self] _ in
                 self.setTabElements()
             }
             .disposed(by: self.disposeBag)

         viewModel.onLogout
             .bind { [unowned self] _ in self.startAppCoordinator() }
             .disposed(by: self.disposeBag)
         
         return viewModel.onDidCancel
             .take(1)
     }
     
     private func popToRoot(_ tabElementIn: TabElement) {
         
         for tabElement in self.tabElements {
             tabElement.tabViewController?.dismiss(animated: true, completion: nil)
             tabElement.tabViewController?.popToRootViewController(animated: false)
             if let coordinatorDestroyer = tabElement as? BaseCoordinatorDisposable {
                 coordinatorDestroyer.disposeChildren()
             }
         }
     }
 }

extension TabbarCoordinator {
    
    func setTabElements() {
        self.tabElements = [self.searchCoordinator]
        self.addTabElements()
    }
    
    func addTabElements() {
        self.viewModel?.addTabElements(tabElements: self.tabElements)
        guard let tabElement = self.tabElements.first else {
            fatalError("tabElements are empty")
        }
        self.showTabElement(tabElement)
    }
    
    func showTabElement(_ tabElement: TabElement) {
        self.viewController?.showChildViewController(viewController: tabElement.tabViewController)
        self.viewModel?.setTabElementSelected(tabElement: tabElement)
    }
}

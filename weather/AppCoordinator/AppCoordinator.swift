//
//  AppCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum AppParameters {
    
    case didFinishLaunching
    case restart
    
    var isAnimated: Bool {
        switch self {
        case .restart:
            return true
        default:
            return false
        }
    }
}

class AppCoordinator: BaseCoordinator
<Void,
 AppInteractor,
 AppParameters,
 AppViewModel,
 AppViewController>
{
    
    private let window: UIWindow
    private var tabbarCoordinator: TabbarCoordinator
    
    init(window: UIWindow, parameters: AppParameters, serviceAPIContainer: ServiceAPIContainer) {
        self.window = window
        
        self.tabbarCoordinator = TabbarCoordinator(window: window,
                                                   parameters: TabbarParameters(),
                                                   serviceAPIContainer: serviceAPIContainer)
        
        super.init(parameters: parameters, serviceAPIContainer: serviceAPIContainer)
    }
    
    override func start(animated: Bool) -> Observable<Void> {
        _ = super.start(animated: animated)
        
        guard
            let viewModel = self.viewModel,
            let viewController = self.viewController
        else { fatalError("viewModel or viewController can't find") }
        
        self.setRootViewController(viewController, animated: parameters.isAnimated)
                
        viewModel.onNeedsShowMainTabbar
            .flatMapLatest { [unowned self] _ in
                return self.showTabbarCoordinator(window: self.window,
                                                  parameters: TabbarParameters(),
                                                  serviceAPIContainer: self.serviceAPIContainer)
            }
            .subscribe()
            .disposed(by: self.disposeBag)
        
//        viewModel.onNeedsShowAuthRoot
//            .flatMapLatest { [unowned self] _ in
//                return self.showAuth(window: self.window,
//                                     parameters: .init(authRootStartScreen: .main),
//                                     serviceAPIContainer: self.serviceAPIContainer)
//            }
//            .flatMapLatest { [unowned self] _ in
//                return self.showTabbarCoordinator(window: self.window,
//                                                  parameters: TabbarParameters(),
//                                                  serviceAPIContainer: self.serviceAPIContainer)
//            }
//            .subscribe()
//            .disposed(by: self.disposeBag)
                
        return viewModel.onDidCancel
            .take(1)
    }
    
    func setRootViewController(_ rootViewController: UIViewController, animated: Bool = true) {
        
        self.window.rootViewController = rootViewController
        self.window.makeKeyAndVisible()
        
        if animated {
            UIView.transition(with: self.window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    // MARK: - TabbarCoordinator
    
    private func showTabbarCoordinator(
        window: UIWindow,
        parameters: TabbarParameters,
        serviceAPIContainer: ServiceAPIContainer) -> Observable<Void> {
            
            self.tabbarCoordinator = TabbarCoordinator(window: window,
                                                       parameters: parameters,
                                                       serviceAPIContainer: serviceAPIContainer)
            
            return self.coordinate(to: self.tabbarCoordinator, animated: true)
        }
    
    // MARK: - OnboardingCoordinator
    
//    private func showOnboarding(
//        window: UIWindow,
//        serviceAPIContainer: ServiceAPIContainer) -> Observable<Void> {
//
//            let onboardingViewCoordinator = OnboardingViewCoordinator(window: window,
//                                                                      serviceAPIContainer: serviceAPIContainer)
//
//            return self.coordinate(to: onboardingViewCoordinator, animated: true)
//                .map { _ in }
//        }
    
    // MARK: - AuthRootCoordinator
    
//    private func showAuth(window: UIWindow, parameters: MainAuthParameters, serviceAPIContainer: ServiceAPIContainer) -> Observable<Void> {
//
//        let coordinator = MainAuthCoordinator(window: window,
//                                              parameters: parameters,
//                                              serviceAPIContainer: serviceAPIContainer)
//        return self.coordinate(to: coordinator, animated: true)
//            .map { _ in }
//    }
}

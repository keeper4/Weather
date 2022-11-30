//
//  AppDelegate.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let disposeBag = DisposeBag()
    internal var apiContainer:  ApiContainer?
    private var appCoordinator: AppCoordinator?
    
    var urlHandlers: [UrlHandlerWeakBox] = []
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        self.apiContainer = ApiContainer.shared
        
        self.setupKeyboardManager()
        self.setBackButtonImage()
        
        self.startAppCoordinator(launchType: .didFinishLaunching)
        
        return true
    }
    
    private var appCoordinatorDisposeBag: DisposeBag?
    
    func startAppCoordinator(launchType: AppParameters) {
        guard let window = self.window else {
            fatalError("not set window")
        }
        
        guard let apiContainer = self.apiContainer else {
            fatalError("not set apiContainer")
        }
        
        let appCoordinatorDisposeBag = DisposeBag()
        self.appCoordinator?.dispose()
        
        self.appCoordinator = AppCoordinator(window: window, parameters: launchType, serviceAPIContainer: apiContainer)
        self.appCoordinator?.start(animated: false)
            .subscribe()
            .disposed(by: appCoordinatorDisposeBag)
        
        self.appCoordinatorDisposeBag = appCoordinatorDisposeBag
    }
    
    var deviceOrientation: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)
    -> UIInterfaceOrientationMask {
        return self.deviceOrientation
    }
    
    private func setBackButtonImage() {
        let backImage = #imageLiteral(resourceName: "icon-back-button")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
    }
}

// MARK: - IQKeyboardManager

extension AppDelegate {
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

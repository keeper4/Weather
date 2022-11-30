//
//  BaseNavigationController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

extension UINavigationController {
    class func baseNavigationController() -> BaseNavigationController {
        let navigationController = BaseNavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        return navigationController
    }
}

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    // MARK: - Private Properties
    private let _popViewController = PublishSubject<UIViewController>()
    private(set) lazy var onPopViewController = self._popViewController.share()
    fileprivate var duringPushAnimation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
       self.interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        self.delegate = nil
        self.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        
        guard let baseNavigationController = navigationController as? BaseNavigationController else { return }
        baseNavigationController.duringPushAnimation = false
        
        guard let fromViewController = navigationController.transitionCoordinator?
                .viewController(forKey: .from) else { return }
        
        guard !navigationController.viewControllers.contains(fromViewController) else { return }
        self._popViewController.onNext(fromViewController)
    }

    // MARK: - Overrides

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        //print("gestureRecognizerShouldBegin 3:\(viewControllers.count > 1)")
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && !self.duringPushAnimation
    }
}

//
//  BaseCoordinator.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseCoordinator
<CompletionResult,
 Interactor: BaseInteractor,
 ViewModelParameters,
 ViewModel: BaseViewControllerViewModel<ViewModelParameters>,
 ViewController: BaseViewController>
{
    let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    var disposeBag = DisposeBag()
    
    let parameters: ViewModelParameters
    let serviceAPIContainer: ServiceAPIContainer
    
    private(set) var viewModel: ViewModel?
    private(set) var viewController: ViewController?
    
    init(parameters: ViewModelParameters, serviceAPIContainer: ServiceAPIContainer = ApiContainer.shared) {
        self.parameters                 = parameters
        self.serviceAPIContainer        = serviceAPIContainer
    }
    
    deinit {
        self.disposeBag = DisposeBag()
        #if DEBUG
        print("\ndeinit \(String(describing: self))\n")
        #endif
    }
    
    func start(animated: Bool) -> Observable<CompletionResult> {
        
        let service = Interactor(apiContainer: self.serviceAPIContainer)
        let viewModel = ViewModel(parameters: self.parameters, service: service)
        let viewController = ViewController.viewControllerFromStoryboard()
        viewController.modalPresentationStyle = .fullScreen
        
        viewModel.alertDisplaying = self
        
        viewController.datasource = viewModel
        
        self.viewModel = viewModel
        self.viewController = viewController
        
        return .empty()
    }
    
    final func coordinate
    <CompletionResult,
     Interactor: BaseInteractor,
     ViewModelParameters,
     ViewModel: BaseViewControllerViewModel<ViewModelParameters>,
     ViewController: BaseViewController>
    (to coordinator: BaseCoordinator<CompletionResult, Interactor, ViewModelParameters, ViewModel, ViewController>,
     animated: Bool) -> Observable<CompletionResult>
    {
        self.store(coordinator: coordinator)
        return coordinator.start(animated: animated)
            .do(onNext: { [weak self, weak coordinator] _ in
                guard let coordinator = coordinator else { return }
                self?.release(coordinator: coordinator)
            })
    }
    
    private func store
    <CompletionResult,
     Interactor: BaseInteractor,
     ViewModelParameters,
     ViewModel: BaseViewControllerViewModel<ViewModelParameters>,
     ViewController: BaseViewController>
    (coordinator: BaseCoordinator<CompletionResult, Interactor, ViewModelParameters, ViewModel, ViewController>)
    {
        self.childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func release
    <CompletionResult,
     Interactor: BaseInteractor,
     ViewModelParameters,
     ViewModel: BaseViewControllerViewModel<ViewModelParameters>,
     ViewController: BaseViewController>
    (coordinator: BaseCoordinator<CompletionResult, Interactor, ViewModelParameters, ViewModel, ViewController>)
    {
        
        self.childCoordinators[coordinator.identifier] = nil
    }
    
    func startAppCoordinator() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.startAppCoordinator(launchType: .restart)
    }
}

protocol BaseCoordinatorDisposable {
    func disposeChildren()
    func dispose()
}

extension BaseCoordinator: BaseCoordinatorDisposable {
    
    func disposeChildren() {
        for case let child as BaseCoordinatorDisposable in self.childCoordinators.values {
            child.dispose()
        }
    }
    
    func dispose() {
        self.disposeChildren()
        self.viewController?.dispose()
        self.viewModel?.dispose()
        self.disposeBag = DisposeBag()
        self.viewController = nil
        self.viewModel = nil
        self.childCoordinators = [:]
    }
}

enum AlertCompletionResult {
    case cancel
    case confirm
}

protocol AlertDisplaying: AnyObject {
    
    func showAlert(title: String, message: String, cancelTitle: String, okTitle: String?)
    -> Observable<AlertCompletionResult>
    
    func showAlert(parameters: AlertParameters) -> Observable<Any>
    
    func showAlertWithTitle(parameters: AlertParameters) -> Observable<Any>
    
    func showError(error: Error) -> Observable<AlertCompletionResult>
    
    func showActionSheet(withParameters parameters: ActionSheetParameters,
                         animated: Bool) -> Observable<ActionSheetCompletionResult>
}

extension BaseCoordinator: AlertDisplaying {
    
    func showActionSheet(withParameters parameters: ActionSheetParameters,
                         animated: Bool) -> Observable<ActionSheetCompletionResult>
    {
        guard
            let viewController = self.viewController
        else { fatalError("no view controller is set") }
        
        let coordinator = ActionSheetCoordinator(presentingViewController: viewController,
                                                 parameters: parameters,
                                                 serviceAPIContainer: self.serviceAPIContainer)
        return self.coordinate(to: coordinator, animated: animated)
    }
    
    func showAlert(title: String, message: String, cancelTitle: String, okTitle: String?)
    -> Observable<AlertCompletionResult>
    {
        return Observable.create { [unowned self] observer in
            let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
//            let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
//                             NSAttributedString.Key.foregroundColor : UIColor.textWhite]
//            let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular),
//                               NSAttributedString.Key.foregroundColor : UIColor.textWhite]
//
//            let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
//            let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
//
//            alertViewController.setValue(titleAttrString, forKey: "attributedTitle")
//            alertViewController.setValue(messageAttrString, forKey: "attributedMessage")
            
            let cancelAction = UIAlertAction(title: cancelTitle,
                                             style: .cancel,
                                             handler: { _ in observer.onNext(.cancel) })
            alertViewController.addAction(cancelAction)
            
            if let okTitle = okTitle {
                let okAction = UIAlertAction(title: okTitle,
                                             style: .default,
                                             handler: { _ in observer.onNext(.confirm) })
                alertViewController.addAction(okAction)
            }
            
            //alertViewController.view.tintColor = .darkOrange
            
            guard
                let viewController = self.viewController
            else { fatalError("no view controller is set") }
            
            viewController.present(alertViewController, animated: true)
            
            return Disposables.create()
        }
    }
    
    func showError(error: Error) -> Observable<AlertCompletionResult> {
        let title = NSLocalizedString("BaseViewController.OperationFailed")
        let okText = NSLocalizedString("BaseViewController.Ok")
        
        return self.showAlert(title: title,
                              message: error.localizedDescription,
                              cancelTitle: okText,
                              okTitle: nil)
    }
}

struct AlertParameters {
    
    struct Action {
        let title: String
        let style: UIAlertAction.Style
        let result: Any
        let action: (() -> Void)?
        
        init(title: String, style: UIAlertAction.Style, result: Any, action: (() -> Void)? = nil) {
            self.title = title
            self.style = style
            self.result = result
            self.action = action
        }
    }
    
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    
    var actions: [Action]
    
    init(title: String? = nil,
         message: String? = nil,
         style: UIAlertController.Style = .actionSheet,
         actions: [Action])
    {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
    }
}

extension BaseCoordinator {
    func showAlert(parameters: AlertParameters) -> Observable<Any> {
        
        return Observable.create { [unowned self] observer in
            
            let alertViewController = UIAlertController(title: nil,
                                                        message: nil,
                                                        preferredStyle: parameters.style)
            alertViewController.view.tintColor = UIColor.white
            alertViewController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
            
            for action in parameters.actions {
                let alertAction = UIAlertAction(title: action.title,
                                                style: action.style,
                                                handler: { _ in
                                                    action.action?()
                                                    observer.onNext(action.result)
                                                })
                
                if action.title == NSLocalizedString("BaseViewController.Cancel") {
                    alertAction.setValue(UIColor.white, forKey: "titleTextColor")
                }
                
                alertViewController.addAction(alertAction)
            }
            
            guard
                let viewController = self.viewController
            else { fatalError("no view controller is set") }
            
            DispatchQueue.main.async { [weak viewController] in
                viewController?.present(alertViewController, animated: true)
            }
            
            return Disposables.create()
        }
    }
    
    func showAlertWithTitle(parameters: AlertParameters) -> Observable<Any> {
        
        return Observable.create { [unowned self] observer in
            
            let alertViewController = UIAlertController(title: parameters.title,
                                                        message: parameters.message,
                                                        preferredStyle: parameters.style)
            
            for action in parameters.actions {
                let alertAction = UIAlertAction(title: action.title,
                                                style: action.style,
                                                handler: { _ in
                                                    action.action?()
                                                    observer.onNext(action.result)
                                                })
                
                alertViewController.addAction(alertAction)
            }
            
            guard
                let viewController = self.viewController
            else { fatalError("no view controller is set") }
            
            DispatchQueue.main.async { [weak viewController] in
                viewController?.present(alertViewController, animated: true)
            }
            
            return Disposables.create()
        }
    }
}

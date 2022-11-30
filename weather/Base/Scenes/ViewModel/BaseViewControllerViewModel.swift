//
//  BaseViewControllerViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ServiceAPIContainer {
    
    var httpRequestAPI:     HTTPRequestAPI  { get }
    var databaseAPI:        DatabaseAPI     { get }
    var userDefaultsAPI:    UserDefaultsAPI { get }
}

protocol BaseService: AnyObject {
    
}

class BaseViewControllerViewModel<Parameters>: ViewModel, BaseViewControllerDatasource {
    // MARK: BaseViewControllerDatasource
    private(set) lazy var title: Driver<String?> = self._title.asDriver(onErrorJustReturn: "")
    
    private(set) lazy var viewDidLoad: AnyObserver<Void> = self._viewDidLoad.asObserver()
    
    private(set) lazy var viewWillAppearAnimated: AnyObserver<Bool> = self._viewWillAppearAnimated.asObserver()
    
    private(set) lazy var viewDidAppearAnimated: AnyObserver<Bool> = self._viewDidAppearAnimated.asObserver()
    
    private(set) lazy var viewWillDisappearAnimated: AnyObserver<Bool> = self._viewWillDisappearAnimated.asObserver()
    
    private(set) lazy var viewDidDisappearAnimated: AnyObserver<Bool> = self._viewDidDisappearAnimated.asObserver()
    
    private(set) lazy var didCancel: AnyObserver<Void> = self._didCancel.asObserver()
    
    // MARK: public
    private(set) lazy var setTitle: AnyObserver<String?>? = self._title.asObserver()
    
    private(set) lazy var onViewDidLoad: Observable<Void> = self._viewDidLoad.share()
    
    private(set) lazy var onViewWillAppearAnimated: Observable<Bool> = self._viewWillAppearAnimated.share()
    
    private(set) lazy var onViewDidAppearAnimated: Observable<Bool> = self._viewDidAppearAnimated.share()
    
    private(set) lazy var onViewWillDisappearAnimated: Observable<Bool> = self._viewWillDisappearAnimated.share()
    
    private(set) lazy var onViewDidDisappearAnimated: Observable<Bool> = self._viewDidDisappearAnimated.share()
    
    private(set) lazy var onDidCancel: Observable<Void> = self._didCancel.share()
    
    weak var alertDisplaying: AlertDisplaying?
    
    final var service: BaseService {
        get {
            return self._service
        }
        set {
            self._service = newValue
            let serviceDisposeBag = DisposeBag()
            self.setupViewModelToServiceBindings(newValue, disposeBag: serviceDisposeBag)
            self.serviceDisposeBag = serviceDisposeBag
        }
    }
    private var _service: BaseService!
    private var serviceDisposeBag: DisposeBag?
    
    var currentTitle: String? {
        get {
            do { return try self._title.value() } catch { fatalError(error.localizedDescription) }
        }
        set {
            self._title.onNext(newValue)
        }
    }
    
    // MARK: private
    private let _title                      = BehaviorSubject<String?>(value: nil)
    private let _viewDidLoad                = PublishSubject<Void>()
    private let _viewWillAppearAnimated     = PublishSubject<Bool>()
    private let _viewDidAppearAnimated      = PublishSubject<Bool>()
    private let _viewWillDisappearAnimated  = PublishSubject<Bool>()
    private let _viewDidDisappearAnimated   = PublishSubject<Bool>()
    private let _didCancel                  = PublishSubject<Void>()
    
    required init(parameters: Parameters, service: BaseService) {
        super.init()
        self.service = service
    }
    
    deinit {
        self.disposeBag = DisposeBag()
        self.serviceDisposeBag = DisposeBag()
#if DEBUG
        print("deinit \(String(describing: self))\n")
#endif
    }
    
    func setupViewModelToServiceBindings(_ service: BaseService, disposeBag: DisposeBag) {}
    
    func makeRetryAlertHandler(ignoringErrors ignoredErrors: [NetworkError] = [],
                               actionBeforeRetrying: (() -> Void)?,
                               cancelAction: (() -> Void)? = nil )
    -> (_ errorObservable: Observable<Error>) -> Observable<Void>
    {
        return { (_ errorObservable: Observable<Error>) -> Observable<Void> in
            errorObservable
                .flatMapLatest { [unowned self] error -> Observable<Void> in
                    switch error {
                    case let error as NetworkError where ignoredErrors.map{ $0.caseName }.contains(error.caseName):
                        throw error
                    default:
                        if let alertDisplaying = self.alertDisplaying, let networkError = error as? NetworkError {
                            
                            let parameters = self.getParamsForActionSheet(errorType: networkError,
                                                                          message: error.localizedDescription,
                                                                          actionBeforeRetrying: actionBeforeRetrying,
                                                                          cancelAction: cancelAction)
                            
                                return alertDisplaying.showActionSheet(withParameters: parameters, animated: true)
                                    .filter {
                                        switch $0 {
                                        case .choosedAnAction(let result) where result != nil:
                                            return true
                                        default:
                                            return false
                                        }
                                    }
                                    .map { _ in }
                            
                        } else {
                            throw error
                        }
                    }
                }
        }
    }
    
    private var showErrorDisposable: Disposable?
    
    func showError(error: Error, completionAction: (() -> Void)? = nil) {
        self.showErrorDisposable = self.alertDisplaying?
            .showError(error: error)
            .subscribe(onNext: { [unowned self] _ in
                completionAction?()
                self.showErrorDisposable?.dispose()
                self.showErrorDisposable = nil
            })
    }
    
    private func getParamsForActionSheet(errorType: NetworkError,
                                         message: String,
                                         actionBeforeRetrying: (() -> Void)?,
                                         cancelAction: (() -> Void)?) -> ActionSheetParameters {
        
            let title = NSLocalizedString("BaseViewController.OperationFailed")
            let retryText = NSLocalizedString("BaseViewController.Retry")
            let cancelText = NSLocalizedString("BaseViewController.Cancel")
            
            let retryAction = ActionSheetParameters.Action(title: retryText,
                                                           color: .dark_bg,
                                                           action:
                                                            {
                                                                actionBeforeRetrying?()
                                                                return "retry"
                                                            })
            
            let cancelAction = ActionSheetParameters.Action(title: cancelText,
                                                            color: .dark_bg,
                                                            action:
                                                                {
                                                                    cancelAction?()
                                                                })
            
            let parameters = ActionSheetParameters(title: title,
                                                   message: message,
                                                   actions: [retryAction, cancelAction],
                                                   cancelsOnTapOutside: false)
            return parameters
    }
}

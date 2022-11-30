//
//  AppViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

protocol AppService: BaseService {

}

class AppViewModel: BaseViewControllerViewModel<AppParameters>, AppViewControllerDatasource {
    
    // MARK: AppViewControllerDatasource
    
    private(set) lazy var showError: Driver<Error?> = self._showError.asDriver(onErrorJustReturn: nil)
    
    // MARK: - public
    private(set) lazy var onNeedsShowMainTabbar: Observable<Void> = self._onNeedsShowMainTabbar.share()
    private(set) lazy var onNeedsShowAuthRoot: Observable<Void> = self._onNeedsShowAuthRoot.share()
    private(set) lazy var onNeedsShowCreateChild: Observable<Void> = self._onNeedsShowCreateChild.share()
    private(set) lazy var onNeedsShowInviteFlow: Observable<Void> = self._onNeedsShowInviteFlow.share()
    private(set) lazy var onStart: AnyObserver<Void> = self._onStart.asObserver()
    
    // MARK: - private
    private let _showError                          = PublishSubject<Error?>()
    private let _onNeedsShowMainTabbar              = PublishSubject<Void>()
    private let _onNeedsShowAuthRoot                = PublishSubject<Void>()
    private let _onNeedsShowCreateChild             = PublishSubject<Void>()
    private let _onUserLoggedin                     = PublishSubject<Void>()
    private let _onStart                            = PublishSubject<Void>()
    private let _onNeedsShowInviteFlow              = PublishSubject<Void>()
    
    private let launchType: AppParameters
    
    required init(parameters: AppParameters, service: BaseService) {
        self.launchType = parameters
        super.init(parameters: parameters, service: service)
    }
    
    override func setupViewModelToServiceBindings(_ service: BaseService, disposeBag: DisposeBag) {
        super.setupViewModelToServiceBindings(service, disposeBag: disposeBag)
        
        guard let service = service as? AppService else { return }
        
        self._onUserLoggedin
//            .flatMapLatest { [unowned service, unowned self] _ -> Observable<UserModel> in
//                return service.fetchUser()
//                    .doOnNextAndOnError { GIFHUD.dismiss() }
//                    .retry(when:self.makeRetryAlertHandler(actionBeforeRetrying: { GIFHUD.show() }))
//            }
            .doOnNextAndOnError { [unowned self] in
                self._onNeedsShowAuthRoot.onNext(())
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        let loaded = Observable.merge(self._onStart, self.onViewDidLoad)
            .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .share()
        
        loaded
            .bind { [unowned self, unowned service] _ in
                switch self.launchType {
                case .didFinishLaunching:
                    self._onNeedsShowMainTabbar.onNext(())
//                    if service.currentUser != nil {
//                        self._onNeedsShowMainTabbar.onNext(())
//                    } else {
//                        self._onNeedsShowAuthRoot.onNext(())
//                    }
                case .restart:
                    self._onNeedsShowAuthRoot.onNext(())
                }
            }
            .disposed(by: disposeBag)
    }
}

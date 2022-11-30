//
//  TabbarViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//
import UIKit
import Foundation
import RxCocoa
import RxSwift

protocol TabbarService: BaseService {
    
}

struct TabbarParameters {
}

class TabbarViewModel: BaseViewControllerViewModel<TabbarParameters>, TabbarDatasource {
    
    // MARK: TabbarDatasource
    
    private(set) lazy var tabbarItemViewDatasources: Observable<[TabbarItemViewDatasource]> = self._tabbarItemViewDatasources
    
    private var _viewModels: [TabbarItemViewModel] = []
    private let _tabbarItemViewDatasources = BehaviorSubject<[TabbarItemViewDatasource]>(value: [])
    private let _onDidTapTabElement = PublishSubject<TabElement>()
    private let _onNeedShowTabElement = PublishSubject<TabElement>()
    private let _onNeedsPopToRoot = PublishSubject<TabElement>()
    private let _onLoggedInAsMain = PublishSubject<Void>()
    private let _logout          = PublishSubject<Void>()
    private let _onNeedShowUpdateAppAlert = PublishSubject<String>()

    private(set) lazy var onNeedShowUpdateAppAlert: Observable<String> = self._onNeedShowUpdateAppAlert.share()
    private(set) lazy var onLoggedInAsMain = self._onLoggedInAsMain.share()
    
    private var selectetTabElement: TabElement?
    private var addTabeElement: TabElement?
    
    
    // MARK: public
    
    private(set) lazy var onLogout = self._logout.share()
    private(set) lazy var onNeedShowTabElement: Observable<TabElement> = self._onNeedShowTabElement.share()
    private(set) lazy var onNeedsPopToRoot: Observable<TabElement> = self._onNeedsPopToRoot.share()
    
    required init(parameters: TabbarParameters, service: BaseService) {
        super.init(parameters: parameters, service: service)

    }
    
    override func setupViewModelToServiceBindings(_ service: BaseService, disposeBag: DisposeBag) {
        super.setupViewModelToServiceBindings(service, disposeBag: disposeBag)
        
        guard let service = service as? TabbarService else { return }
        
        let loaded = self.onViewDidLoad
            .debounce(RxTimeInterval.milliseconds(2), scheduler: MainScheduler.instance)
            .share()
        
        loaded
            .bind(to: self._onLoggedInAsMain)
            .disposed(by: disposeBag)

        
        self._onDidTapTabElement
            .bind(to: self._onNeedShowTabElement)
            .disposed(by: disposeBag)
    }
    
    var tabElementsDisposeBag: DisposeBag?
    
    func addTabElements(tabElements: [TabElement], at index: Int? = nil) {
        let tabbarItemViewViewModels = tabElements.map { TabbarItemViewModel(tabElement: $0) }
        let tabElementsDisposeBag = DisposeBag()
        
        for tabbarItemViewViewModel in tabbarItemViewViewModels {
            tabbarItemViewViewModel.onTapped
                .delay(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
                .map { [unowned tabbarItemViewViewModel] in tabbarItemViewViewModel.tabElement }
                .filter { [unowned self] in $0 !== self.selectetTabElement }
                .bind(to: self._onDidTapTabElement)
                .disposed(by: tabElementsDisposeBag)
            
            tabbarItemViewViewModel.onTapped
                .map { [unowned tabbarItemViewViewModel] in tabbarItemViewViewModel.tabElement }
                .filter { [unowned self] in $0 === self.selectetTabElement }
                .bind(to: self._onNeedsPopToRoot)
                .disposed(by: tabElementsDisposeBag)
        }
        
        self._viewModels = tabbarItemViewViewModels
        
        self._tabbarItemViewDatasources.onNext(self._viewModels)
        
        self.tabElementsDisposeBag = tabElementsDisposeBag
    }
    
    func setTabElementSelected(tabElement: TabElement) {
        self._viewModels.forEach { [unowned self] viewModel in
            
            if viewModel.tabElement === tabElement {
                self.selectetTabElement = tabElement
                viewModel.onItemSelected.onNext(true)
            } else {
                viewModel.onItemSelected.onNext(false)
            }
        }
    }
}

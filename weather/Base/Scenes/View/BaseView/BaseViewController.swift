//
//  BaseViewController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RxCocoa
import RxSwift

protocol BaseViewControllerDatasource: ViewDatasource {
    
    var title:                      Driver<String?> { get }
    
    var viewDidLoad:                AnyObserver<Void>   { get }
    var viewWillAppearAnimated:     AnyObserver<Bool>   { get }
    var viewDidAppearAnimated:      AnyObserver<Bool>   { get }
    var viewWillDisappearAnimated:  AnyObserver<Bool>   { get }
    var viewDidDisappearAnimated:   AnyObserver<Bool>   { get }
    
    var didCancel:                  AnyObserver<Void>   { get }
}

class BaseViewController: UIViewController, View, ViewControllerFromStoryboard {
    
    var disposeBag = DisposeBag()
    
    func dispose() {
        self.disposeBag = DisposeBag()
    }
    
    final var datasource: ViewDatasource! {
        get {
            return self._datasource
        }
        set {
            self._datasource = newValue
            
            if let datasource = newValue as? BaseViewControllerDatasource {
                
                datasource.title
                    .drive(self.titleBinder)
                    .disposed(by: disposeBag)
                
                self.rx.methodInvoked(#selector(viewDidLoad))
                    .map { _ in }
                    .bind(to: datasource.viewDidLoad)
                    .disposed(by: disposeBag)
                
                self.rx.methodInvoked(#selector(viewWillAppear))
                    .map { $0[0] as! Bool }
                    .bind(to: datasource.viewWillAppearAnimated)
                    .disposed(by: disposeBag)
                
                self.rx.methodInvoked(#selector(viewDidAppear))
                    .map { $0[0] as! Bool }
                    .bind(to: datasource.viewDidAppearAnimated)
                    .disposed(by: disposeBag)
                
                self.rx.methodInvoked(#selector(viewWillDisappear))
                    .map { $0[0] as! Bool }
                    .bind(to: datasource.viewWillDisappearAnimated)
                    .disposed(by: disposeBag)
                
                self.rx.methodInvoked(#selector(viewDidDisappear))
                    .map { $0[0] as! Bool }
                    .bind(to: datasource.viewDidDisappearAnimated)
                    .disposed(by: disposeBag)
                
                Observable.of(
                    self.backBarButtonItem.rx.tap,
                    self.backBarButtonItemWithCross.rx.tap)
                .merge()
                .take(1)
                .bind(to: datasource.didCancel)
                .disposed(by: disposeBag)
                
                if self.isViewLoaded {
                    let datasourceDisposeBag = DisposeBag()
                    self.setupInterfaceToDatasourceBindings(datasource, disposeBag: datasourceDisposeBag)
                    self.datasourceDisposeBag = datasourceDisposeBag
                }
            }
        }
    }
    private var _datasource: ViewDatasource!
    private var datasourceDisposeBag: DisposeBag?
    
    func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource, disposeBag: DisposeBag) {}
    
    let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back-button"), style: .plain, target: nil, action: nil)
    let backBarButtonItemWithCross = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-close-white"), style: .plain, target: nil, action: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var shouldShowNavigationBar: Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    deinit {
        self.disposeBag = DisposeBag()
        self.datasourceDisposeBag = DisposeBag()
#if DEBUG
        print("\ndeinit \(String(describing: self))\n")
#endif
    }
    
    func commonInit() {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in }
            .subscribe(onNext: { [unowned self] in
                guard let datasource = self.datasource as? BaseViewControllerDatasource else { return }
                
                let datasourceDisposeBag = DisposeBag()
                self.setupInterfaceToDatasourceBindings(datasource, disposeBag: datasourceDisposeBag)
                self.datasourceDisposeBag = datasourceDisposeBag
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        let customBackButton = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = customBackButton
        
        self.backBarButtonItem.accessibilityIdentifier = "close_accessibility_action"
        self.backBarButtonItemWithCross.accessibilityIdentifier = "close_accessibility_action"
    }
    
    private var previousNavigationBarHiddenState: Bool?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.previousNavigationBarHiddenState = self.navigationController?.isNavigationBarHidden
        
        self.navigationController?.setNavigationBarHidden(!self.shouldShowNavigationBar, animated: animated)
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 40.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        if let previousNavigationBarHiddenState = self.previousNavigationBarHiddenState {
            self.navigationController?.setNavigationBarHidden(previousNavigationBarHiddenState, animated: animated)
        }
    }
    
    var titleBinder: Binder<String?> {
        return Binder(self) { target, title in
            target.navigationItem.title = title
        }
    }
    
    private var navBarTintColor: UIColor?
    private var navBarBarTintColor: UIColor?
    private var navBarBackgroundImage: UIImage?
    private var navBarShadowImage: UIImage?
    private var navBarIsTranslucent: Bool = false
    private var navBarTitleTextAttributes: [NSAttributedString.Key : Any]?
}

extension BaseViewController {
    @objc
    func setupNavigationBarStyle() {}
    
    func saveNavigationBarStyle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        self.navBarTintColor = navigationBar.tintColor
        self.navBarBarTintColor = navigationBar.barTintColor
        self.navBarBackgroundImage = navigationBar.backgroundImage(for: .default)
        self.navBarShadowImage = navigationBar.shadowImage
        self.navBarIsTranslucent = navigationBar.isTranslucent
        self.navBarTitleTextAttributes = navigationBar.titleTextAttributes
    }
    
    func returnNavigationBarStyle() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.tintColor = self.navBarTintColor
        navigationBar.barTintColor = self.navBarBarTintColor
        navigationBar.setBackgroundImage(self.navBarBackgroundImage, for: .default)
        navigationBar.shadowImage = self.navBarShadowImage
        navigationBar.isTranslucent = self.navBarIsTranslucent
        navigationBar.titleTextAttributes = self.navBarTitleTextAttributes
    }
}

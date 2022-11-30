//
//  TabbarViewController.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import UIKit
import RxSwift

protocol TabbarDatasource: BaseViewControllerDatasource {
    
    var tabbarItemViewDatasources: Observable<[TabbarItemViewDatasource]>    { get }
}

class TabbarViewController: BaseViewController {
    
    @IBOutlet private weak var contentView       : UIView!
    @IBOutlet private weak var tabbarView        : UIView!
    @IBOutlet private weak var tabbarStackView   : UIStackView!
    
    override func dispose() {
        self.tabbarStackView.subviews.forEach { $0.removeFromSuperview() }
        self.tabbarStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for child in self.children {
            self.remove(asChildViewController: child)
        }
        self.disposeBag = DisposeBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func setupInterfaceToDatasourceBindings(_ datasource: BaseViewControllerDatasource,
                                                     disposeBag: DisposeBag) {
        super.setupInterfaceToDatasourceBindings(datasource, disposeBag: disposeBag)
        
        guard let datasource = self.datasource as? TabbarDatasource else { return }
        
        datasource.tabbarItemViewDatasources
            .observe(on:MainScheduler.instance)
            .bind { [unowned self] elements in
                self.tabbarStackView.subviews.forEach { $0.removeFromSuperview() }
                for element in elements {
                    let tabItemView = TabbarItemView()
                    tabItemView.datasource = element
                    if element.isItemDisable {
                        tabItemView.alpha = 0
                    }
                    self.tabbarStackView.addArrangedSubview(tabItemView)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private var activeViewController: UIViewController? {
        didSet {
            if let oldVC = oldValue {
                self.remove(asChildViewController: oldVC)
            }
            if let activeVC = activeViewController {
                self.add(asChildViewController: activeVC)
            }
        }
    }
    
    func showChildViewController(viewController: UIViewController?) {
        if self.contentView != nil {
            self.activeViewController = viewController
        } else {
            self.rx.methodInvoked(#selector(viewDidLoad))
                .bind { [unowned self, weak viewController] _ in
                    self.activeViewController = viewController
                }
                .disposed(by: self.disposeBag)
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        self.addChild(viewController)
        self.contentView.addSubviewExpanded(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

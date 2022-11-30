//
//  RefreshHandler.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import UIKit

class RefreshHandler: NSObject {
    let startRefresh = PublishSubject<Void>()
    let manualStartRefresh = PublishSubject<Void>()
    let endRefresh = PublishSubject<Bool>()
    let refreshControl = UIRefreshControl()
    let disposeBag = DisposeBag()
    
    init(view: UIScrollView) {
        super.init()

        let contentOffsetY = view.contentOffset.y
        self.refreshControl.tintColor = .white
        view.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh(_:)), for: .valueChanged)
        
        self.endRefresh
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] animated in
                self.refreshControl.endRefreshing()
                if animated {
                    view.setContentOffset(CGPoint(x: 0, y: contentOffsetY), animated: true)
                    UIView.animate(withDuration: 0.25) {
                        view.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: self.disposeBag)

        self.manualStartRefresh
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] _ in
                self.refreshControl.beginRefreshing()

                if view.contentOffset.y > -20 && view.contentOffset.y <= 0 {
                    view.setContentOffset(CGPoint(x: 0, y: view.contentOffset.y - self.refreshControl.frame.height),
                                          animated: true)
                    UIView.animate(withDuration: 0.25) {
                        view.layoutIfNeeded()
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    @objc
    private func refreshControlDidRefresh(_ control: UIRefreshControl) {
        self.startRefresh.onNext(())
    }
}

//
//  BindableType.swift
//  digitalmedia
//
//  Created by Samatbek on 10/9/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType: AnyObject {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: NBaseViewController{
    func bind(to model: Self.ViewModelType) {
        guard let viewModel = model as? NBaseViewControllerViewModel else {
            fatalError("viewModel should be instance of NBaseViewControllerViewModel")
        }
        self.viewModel = model
        self.bindViewModelToLifeCycle(to: viewModel)
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UITableViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

extension BindableType where Self: UICollectionViewCell {
    func bind(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
    }
}

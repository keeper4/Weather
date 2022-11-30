//
//  ActionSheetActionViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import UIKit
class ActionSheetActionViewModel: BaseViewViewModel, ActionSheetActionViewDatasource {

    // MARK: ActionSheetActionViewDatasource
    let title: String
    let color: UIColor

    private(set) lazy var tap: AnyObserver<Void> = self._onTap.asObserver()

    // MARK: - public
    private(set) lazy var onTap = self._onTap.share()

    // MARK: - private
    private let _onTap = PublishSubject<Void>()

    init(title: String, color: UIColor) {
        self.title = title
        self.color = color
    }
}


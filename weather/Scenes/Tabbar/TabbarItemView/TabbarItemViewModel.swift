//
//  TabbarItemViewModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class TabbarItemViewModel: BaseViewViewModel, TabbarItemViewDatasource {
    
    private(set) var tabbarItemImage: String

    private(set) lazy var isTabbarItemSelected: Observable<Bool> = self._isTabbarItemSelected.share(replay: 1)

    private(set) lazy var tapItem: AnyObserver<Void> = self._tapItem.asObserver()
    
    // MARK: - public
    private(set) lazy var onTapped  = self._tapItem.share()
    private(set) lazy var onItemSelected = self._isTabbarItemSelected.asObserver()
    
    var tabElementType: TabElementType {
        return self.tabElement.tabElementType
    }
    let tabElement: TabElement

    // MARK: - private
    private let _isTabbarItemSelected   = BehaviorSubject<Bool>(value: false)
    private let _tapItem                = PublishSubject<Void>()
    
    var isItemDisable:              Bool
        
    required init(tabElement: TabElement) {
        self.tabElement = tabElement
        self.isItemDisable      = !tabElement.itemEnable
        self.tabbarItemImage    = tabElement.tabIcon
    }
}

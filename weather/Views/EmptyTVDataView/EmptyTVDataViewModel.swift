//
//  EmptyTVDataViewModel.swift
//  digitalmedia
//
//  Created by Oleksandr Chyzh on 14.07.2020.
//  Copyright © 2020 Oolla. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EmptyTVDataViewModel: BaseViewViewModel, EmptyTVDataViewDatasource {
    
    private(set) lazy var titleText: Driver<String> = self._titleText.asDriver(onErrorJustReturn: "")
    var image: String
    
    private let _titleText: BehaviorSubject<String>
    
    private(set) lazy var onSetTitle: AnyObserver<String> = self._titleText.asObserver()
    
    init(titleText: String) {
        
        self._titleText = BehaviorSubject<String>(value: titleText)
        self.image = ""
        
        super.init()
    }
}

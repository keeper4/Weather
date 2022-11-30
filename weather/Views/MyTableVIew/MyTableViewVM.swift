//
//  MyTableViewVM.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

class MyTableViewVM: BaseViewViewModel, MyTableViewDatasource {
    
    //MyTableViewDatasource
    private(set) lazy var sections: Driver<[ViewDatasourceSection]> = self._sections.asDriver(onErrorJustReturn: [])
    private(set) lazy var selectDS: AnyObserver<ViewDatasource> = self._selectDS.asObserver()
    
    private let _sections = BehaviorSubject<[ViewDatasourceSection]>(value: [])
    private let _selectDS = PublishSubject<ViewDatasource>()

    private(set) lazy var onSections: AnyObserver<[ViewDatasourceSection]> = self._sections.asObserver()
    private(set) lazy var onSelectDS: Observable<ViewDatasource> = self._selectDS.share()
}

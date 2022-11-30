//
//  BaseModelStorage.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper
import RxSwift

class BaseModelStorage {

    private class WeakRefWrapper {
        weak var model: BaseModel?
        var deinitDisposable: Disposable?

        init(model: BaseModel) {
            self.model = model
        }
    }

    private var modelsMap = [String : [Int : WeakRefWrapper]]()

    func model<T>(ofType type: T.Type, for key: Int) -> T? where T: BaseModel {
        let typeString = String(describing: type)
        return self.modelsMap[typeString]?[key]?.model as? T
    }

    func store<T>(_ model: T, for key: Int) where T: BaseModel {
        let wrapper     = WeakRefWrapper(model: model)
        let typeString  = String(describing: type(of: model))

        if self.modelsMap[typeString] == nil {
            self.modelsMap[typeString] = [:]
        }

        self.modelsMap[typeString]?[key] = wrapper
        wrapper.deinitDisposable = model.onDeinit
            .subscribe(onNext: { [weak self] in //[unowned self] in
                self?.modelsMap[typeString]?[key]?.deinitDisposable?.dispose()
                self?.modelsMap[typeString]?[key] = nil
            })
    }
}

protocol BaseModelMappingContext: MapContext {

    var baseModelStorage: BaseModelStorage { get }
}

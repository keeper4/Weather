//
//  BaseModel.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper
import RxSwift

// MARK: Updatable
protocol Updatable: BaseMappable {

    func update(with JSON: [String : Any], context: BaseModelMappingContext)

    var onUpdated: Observable<Void> { get }
}

// MARK: - BaseModel
class BaseModel: Mappable, Updatable {

    let identifier              = UUID()
    let disposeBag              = DisposeBag()

    fileprivate let _onDeinit   = PublishSubject<Void>()
    fileprivate let _onUpdated  = PublishSubject<Void>()

    private(set) lazy var onDeinit: Observable<Void> = self._onDeinit.share()

    private(set) lazy var onUpdated: Observable<Void> = self._onUpdated.share()

    internal init() {}

    deinit {
        self._onDeinit.onNext(())
    }

    // MARK: Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {}
    
    func mapArrayWithContext<T: BaseModel>(_ key: String, map: Map) -> [T] {
        guard let JSONObject = map.JSON[key] else { return [] }
        guard let context = map.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }
        return Mapper<T>.baseModels(from: JSONObject, context: context) ?? []
    }
    
    func mapArrayWithContext<T: BaseModel>(_ key: String, map: Map, type: T.Type) -> [T] {
        guard let JSONObject = map.JSON[key] else { return [] }
        guard let context = map.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }
        return Mapper<T>.baseModels(from: JSONObject, context: context) ?? []
    }
    
    func mapObjectWithContext<T: BaseModel>(_ key: String, map: Map) -> T? {
        guard let JSONObject = map.JSON[key] else { return nil }
        guard let context = map.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }
        return Mapper<T>.baseModel(from: JSONObject, context: context)
    }
}

extension Updatable where Self: BaseModel {

    func update(with JSON: [String : Any], context: BaseModelMappingContext) {

        if !self.toJSON().isContained(in: JSON) {
            let mapper = Mapper<Self>(context: context, shouldIncludeNilValues: true)
            _ = mapper.map(JSON: JSON, toObject: self)

            self._onUpdated.onNext(())
        }
    }
}

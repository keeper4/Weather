//
//  ObjectMapperOperators.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

import ObjectMapper
import RxSwift

func >>> <T: BehaviorSubject<U>, U>(left: T, right: Map) {
    if let value = try? left.value() {
        value >>> right
    }
}

func >>> <T: BehaviorSubject<U>, U>(left: T?, right: Map) {
    if let value = try? left?.value() {
        value >>> right
    }
}

// MARK: - single primitive
// MARK: BehaviorSubject<Primitive>
func <- <T: BehaviorSubject<U>, U>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        if let value = right.currentValue as? U {
            left.onNext(value)
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: BehaviorSubject<Primitive?>
func <- <T: BehaviorSubject<U?>, U>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        if right.isKeyPresent, let value = right.currentValue as? U {
            left.onNext(value)
        } else {
            left.onNext(nil)
        }

    case .toJSON:
        left >>> right
    }
}

// MARK: - array of primitives
// MARK: BehaviorSubject<[Primitive]>
func <- <T: BehaviorSubject<[U]>, U>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        if let values = right.currentValue as? [U] {
            left.onNext(values)
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: -
// MARK: - single BaseModel
// MARK: BaseModel
func <- <T: BaseModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let json = right.currentValue as? [String : Any] {
            left.update(with: json, context: context)
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: BaseModel?
func <- <T: BaseModel>(left: inout T?, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let json = right.currentValue as? [String : Any] {
            if left != nil {
                left?.update(with: json, context: context)
            } else {
                left = Mapper<T>.baseModel(from: json, context: context)
            }
        } else {
            left = nil
        }

    case .toJSON:
        left >>> right
    }
}

// MARK: BehaviorSubject<BaseModel>
func <- <T: BehaviorSubject<U>, U: BaseModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let json = right.currentValue as? [String : Any] {
            do {
                let value = try left.value()
                value.update(with: json, context: context)
                left.onNext(value)
            } catch {}
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: BehaviorSubject<BaseModel?>
func <- <T: BehaviorSubject<U?>, U: BaseModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let json = right.currentValue as? [String : Any] {
            do {
                let value = try left.value()
                if value != nil {
                    value?.update(with: json, context: context)
                    left.onNext(value)
                } else {
                    let value = Mapper<U>.baseModel(from: json, context: context)
                    left.onNext(value)
                }
            } catch {}
        } else {
            left.onNext(nil)
        }

    case .toJSON:
        left >>> right
    }
}

// MARK: - array of BaseModels
// MARK: [BaseModel]?
func <- <T: BaseModel>(left: inout [T]?, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let jsons = right.currentValue as? [[String : Any]] {
            if left != nil {
                left?.update(with: jsons, context: context)
            } else {
                left = Mapper<T>.baseModels(from: jsons, context: context)
            }
        } else {
            left = nil
        }

    case .toJSON:
        left >>> right
    }
}

// MARK: [BaseModel]
func <- <T: BaseModel>(left: inout [T], right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let jsons = right.currentValue as? [[String : Any]] {
            left.update(with: jsons, context: context)
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: BehaviorSubject<[BaseModel]>
func <- <T: BehaviorSubject<[U]>, U: BaseModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let jsons = right.currentValue as? [[String : Any]] {
            do {
                var values = try left.value()
                values.update(with: jsons, context: context)
                left.onNext(values)
            } catch {}
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: -
// MARK: - single BaseIdModel
// MARK: BaseIdModel?
func <- <T: BaseIdModel>(left: inout T?, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let json = right.currentValue as? [String : Any] {
            if left != nil {
                left?.update(with: json, context: context)
                return
            } else if let id = json["id"] as? Int {
                if let model = context.baseModelStorage.model(ofType: T.self, for: id) {
                    model.update(with: json, context: context)
                    left = model
                } else if let value = Mapper<T>.baseModel(from: json, context: context) {
                    left = value
                }
                return
            }
        }

        left = nil

    case .toJSON:
        left >>> right
    }
}

// MARK: BehaviorSubject<BaseIdModel?>
func <- <T: BehaviorSubject<U?>, U: BaseIdModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let json = right.currentValue as? [String : Any] {
            do {
                let value = try left.value()
                if value != nil {
                    value?.update(with: json, context: context)
                    left.onNext(value)
                    return
                } else if let id = json["id"] as? Int {
                    if let model = context.baseModelStorage.model(ofType: U.self, for: id) {
                        model.update(with: json, context: context)
                        left.onNext(model)
                    } else if let value = Mapper<U>.baseModel(from: json, context: context) {
                        left.onNext(value)
                    }
                    return
                }
            } catch {}
        }

        left.onNext(nil)

    case .toJSON:
        left >>> right
    }
}

// MARK: - array of BaseIdModels
// MARK: [BaseIdModel]?
func <- <T: BaseIdModel>(left: inout [T]?, right: Map) {
    switch right.mappingType {
    case .fromJSON:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if right.isKeyPresent, let jsons = right.currentValue as? [[String : Any]] {
            if left != nil {
                left?.update(with: jsons, context: context)
            } else {
                left = Mapper<T>.baseModels(from: jsons, context: context)
            }
        } else {
            left = nil
        }

    case .toJSON:
        left >>> right
    }
}

// MARK: [BaseIdModel]
func <- <T: BaseIdModel>(left: inout [T], right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let jsons = right.currentValue as? [[String : Any]] {
            left.update(with: jsons, context: context)
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

// MARK: BehaviorSubject<[BaseIdModel]>
func <- <T: BehaviorSubject<[U]>, U: BaseIdModel>(left: inout T, right: Map) {
    switch right.mappingType {
    case .fromJSON where right.isKeyPresent:
        guard let context = right.context as? BaseModelMappingContext else {
            fatalError("incorrect mapping context used")
        }

        if let jsons = right.currentValue as? [[String : Any]] {
            do {
                var values = try left.value()
                values.update(with: jsons, context: context)
                left.onNext(values)
            } catch {}
        }

    case .toJSON:
        left >>> right

    default: ()
    }
}

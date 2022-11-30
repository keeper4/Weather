//
//  DifferenceCheckable.swift
//  Weather
//
//  Created by Oleksandr Chyzh on 29.11.2022.
//  Copyright © 2022 Oleksandr Chyzh. All rights reserved.
//

import Foundation

protocol DifferenceCheckable {

    func isContained(in otherDict: Self) -> Bool
}

extension DifferenceCheckable where Self == [String : Any] {

    func isContained(in otherDict: Self) -> Bool {
        //if self.count > otherDict.count {
        if self.count != otherDict.count {
            return false
        }

        for (key, value) in self {
            if let otherValue = otherDict[key] {
                if let value = value as? Self,
                    let otherValue = otherValue as? Self,
                    !value.isContained(in: otherValue)
                {
                    return false
                } else if !compare(value, to: otherValue) {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}

extension Dictionary: DifferenceCheckable where Key == String, Value == Any {}

private func compare(_ one: Any, to another: Any) -> Bool {
    switch (one, another) {
    case let (one       as [String : Any],
              another   as [String : Any]):
        return one == another

    case let (one       as [Any],
              another   as [Any]):
        return one == another

    case let (one       as Bool,
              another   as Bool):
        return one == another

    case let (one       as Int,
              another   as Int):
        return one == another

    case let (one       as Float,
              another   as Float):
        return one == another

    case let (one       as Double,
              another   as Double):
        return one == another

    case let (one       as String,
              another   as String):
        return one == another

    case let (one       as NSNumber,
              another   as NSNumber):
        return one == another

    case let (one       as BaseModel,
              another   as BaseModel):
        return one.toJSON() == another.toJSON()

    case let (one       as NSObject,
              another   as NSObject):
        return one.isEqual(another)

    case let (one       as AnyObject,
              another   as AnyObject):
        return one === another

    default:
        assert(false, "comparing unsupported types")
        return false
    }
}

extension Equatable where Self == [String : Any] {

    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        for (lKey, lValue) in lhs {
            if let rValue = rhs[lKey] {
                if !compare(lValue, to: rValue) {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
}

extension Equatable where Self == [Any] {

    static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.count != rhs.count {
            return false
        }

        for (index, lValue) in lhs.enumerated() {
            let rValue = rhs[index]
            if !compare(lValue, to: rValue) {
                return false
            }
        }
        return true
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        return !(lhs == rhs)
    }
}

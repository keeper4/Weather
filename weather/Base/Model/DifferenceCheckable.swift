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
        return NSDictionary(dictionary: one).isEqual(another)
        //return one == another
        
            case let (one       as [Any],
                      another   as [Any]):
        return compareAnyArray(one, to: another)
        
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
        return NSDictionary(dictionary: one.toJSON()).isEqual(another.toJSON())
        
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

private func compareAnyArray(_ one: [Any], to another: [Any]) -> Bool {
    // Check if the arrays have the same number of elements
    guard one.count == another.count else {
        return false
    }

    // Iterate through the elements of the arrays and compare them
    for (element1, element2) in zip(one, another) {
        // Use optional casting to compare elements of the same type
        if let value1 = element1 as? Int, let value2 = element2 as? Int {
            if value1 != value2 {
                return false
            }
        } else if let str1 = element1 as? String, let str2 = element2 as? String {
            if str1 != str2 {
                return false
            }
        } else {
            // Handle other types or return false if they cannot be compared
            return false
        }
    }

    // All elements match, return true
    return true
}

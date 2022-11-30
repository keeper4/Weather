//
//  String+Validation+Extentions.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 5/28/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import UIKit

enum ValidatePasswordOptions {
    
    case shortLength
    case toManySymbols
    case lowerCaseLetter
    case upperCaseLetter
    case specialSymbols
    case decimalDigits
    
    case passwordsAreNotTheSame
    case strongPassword
    
    var description: String {
        switch self {
        case .shortLength:
            return NSLocalizedString("ValidatePasswordOptions.shortLength")
        case .toManySymbols:
            return NSLocalizedString("ValidateNameOptions.toManySymbols")
        case .lowerCaseLetter:
            return NSLocalizedString("ValidatePasswordOptions.lowerCaseLetter")
        case .upperCaseLetter:
            return NSLocalizedString("ValidatePasswordOptions.upperCaseLetter")
        case .specialSymbols:
            return NSLocalizedString("ValidatePasswordOptions.specialSymbol")
        case .decimalDigits:
            return NSLocalizedString("ValidatePasswordOptions.decimalDigits")
        case .passwordsAreNotTheSame:
            return NSLocalizedString("ValidatePasswordOptions.passwordsAreNotTheSame")
        case .strongPassword:
            return NSLocalizedString("ValidatePasswordOptions.strongPassword")
        }
    }
}

enum ValidateEmailOptions {
    
    case notValid
    
    var description: String {
        switch self {
        case .notValid:
            return NSLocalizedString("ValidateEmailOptions.notValid")
        }
    }
}

enum ValidateNameOptions {
    
    case toFewSymbols
    case toManySymbols
    
    var description: String {
        switch self {
        case .toFewSymbols:
            return NSLocalizedString("ValidateNameOptions.toFewSymbols")
        case .toManySymbols:
            return NSLocalizedString("ValidateNameOptions.toManySymbols")
        }
    }
}

enum ValidateHashTagsOptions {
    
    case notHashtags
    case toManySymbols
    case countLimit
    
    var description: String {
        switch self {
        case .notHashtags:
            return NSLocalizedString("ValidateHashTagsOptions.notHashtags")
        case .toManySymbols:
            return NSLocalizedString("ValidateNameOptions.toManySymbols")
            case .countLimit:
                return NSLocalizedString("ValidateHashTagsOptions.countLimit")
        }
    }
}

enum ValidateCommonOptions {
    
    case requiredField
    case inputNonEmptyValue
    case toManySymbols
    case phone
    
    var description: String {
        switch self {
        case .requiredField:
            return NSLocalizedString("ValidateCommonOptions.requiredField")
        case .inputNonEmptyValue:
            return NSLocalizedString("ValidateCommonOptions.inputNonEmptyValue")
        case .toManySymbols:
            return NSLocalizedString("ValidateNameOptions.toManySymbols")
        case .phone:
            return NSLocalizedString("ValidateNameOptions.invalidPhoneNumber")
        }
    }
}

enum ValidateDynamicOptions {
    
    case requiredField
    case inputNonEmptyValue
    case toManySymbols
    case phone
    case toFewSymbols
    case cantBeMore
    
    var description: String {
        switch self {
        case .requiredField:
            return NSLocalizedString("ValidateCommonOptions.requiredField")
        case .inputNonEmptyValue:
            return NSLocalizedString("ValidateCommonOptions.inputNonEmptyValue")
        case .toManySymbols:
            return NSLocalizedString("ValidateNameOptions.toManySymbols")
        case .phone:
            return NSLocalizedString("ValidateNameOptions.invalidPhoneNumber")
        case .toFewSymbols:
            return NSLocalizedString("ValidateNameOptions.toFewSymbols")
        case .cantBeMore:
            return NSLocalizedString("ValidateNameOptions.cantBeMore")
        }
    }
}

extension String {
    
    func validateAsEmail() -> [ValidateEmailOptions] {
        var options: [ValidateEmailOptions] = [.notValid]
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", Regex.email)
        
        if predicate.evaluate(with: self.trimmingCharacters(in: .whitespacesAndNewlines)), self.count <= 100 {
            options.removeAll { $0 == .notValid }
        }
        
        return options
    }
    
    func validateAsPassword() -> [ValidatePasswordOptions] {
        var options: [ValidatePasswordOptions] =
            [.shortLength, .lowerCaseLetter, .decimalDigits, .upperCaseLetter]
        
        let minPassLength = 8
        let maxLength = 100
        
        if self.count >= minPassLength {
            options.removeAll { $0 == .shortLength }
        }
        
        if self.rangeOfCharacter(from: CharacterSet.lowercaseLetters) != nil {
            options.removeAll { $0 == .lowerCaseLetter }
        }
        
        if self.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
            options.removeAll { $0 == .upperCaseLetter }
        }
        
        if self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            options.removeAll { $0 == .decimalDigits }
        }
        
//        if self.rangeOfCharacter(from: CharacterSet(charactersIn: "~!@#$%^&*()-=+?_")) != nil {
//            options.removeAll { $0 == .specialSymbols }
//        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= maxLength {
            options.append(.toManySymbols)
        } else {
            options.removeAll { $0 == .toManySymbols }
        }
        
        return options
    }
    
//    func validateAsName(canBeEmpty: Bool = true) -> [ValidateNameOptions] {
//        var options: [ValidateNameOptions] = [.toFewSymbols]
//
//        let minLength = 1
//        let maxLength = 32
//
//        let count = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count
//
//        if count >= minLength {
//            options.removeAll { $0 == .toManySymbols }
//            options.removeAll { $0 == .toFewSymbols }
//        }
//
//        if count > maxLength {
//            options.append(.toManySymbols)
//        }
//
//        if canBeEmpty == false, count == 0 {
//            options.append(.toFewSymbols)
//        }
//
//        return options
//    }
    
    func validateAsNickName() -> [ValidateNameOptions] {
        var options: [ValidateNameOptions] = []
        
        let maxLength = 100
        
        let count = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count
        
        if count >= maxLength {
            options.append(.toManySymbols)
        }
        
        return options
    }
    
    func validateAsHashTags(maxLength: Int = 255, countLimit: Int = 100) -> [ValidateHashTagsOptions] {
        var options: [ValidateHashTagsOptions] = []
        
        if self.isEmpty {
            return options
        }
        
        let words = self.components(separatedBy: " ").filter { !$0.isEmpty }
        let predicate = NSPredicate(format:"SELF MATCHES %@", "(#[\\p{L}0-9]*)")
        
        for word in words {
            if !(predicate.evaluate(with: word) && word.count > 1) {
                options = [.notHashtags]
                options.removeAll { $0 == .toManySymbols }
            }
        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count >= maxLength {
            options.append(.toManySymbols)
        }
        
        if self.components(separatedBy: "#").filter({ !$0.isEmpty }).count >= countLimit {
            options.append(.countLimit)
        }
        
        return options
    }
    
    func getHashTagsArray() -> [String] {
        
        if let regex = try? NSRegularExpression(pattern: "(#[\\p{L}0-9]*)", options: .caseInsensitive) {
            let string = self as NSString
            
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length))
                .map {
                    string.substring(with: $0.range).lowercased()
            }
        }
        
        return []
    }
    
    func validateAsDateOfBirth() -> String? {
        return self.isValid(regex: Regex.dateOfBirth, min: 6, max: 7)
    }
    
    func validateAsSize() -> String? {
        return self.isValid(regex: Regex.size, min: 1, max: 3)
    }
    
    func validateAsNumbers() -> String? {
        return self.isValid(regex: Regex.numbers, min: 1, max: 5)
    }
    
    func validateAsCommon(maxLength: Int = 100, canBeEmpty: Bool = false) -> [ValidateCommonOptions] {
        var options: [ValidateCommonOptions] = []
        
        if canBeEmpty, !self.isEmpty, self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            options.append(.inputNonEmptyValue)
        } else if !canBeEmpty, !self.isEmpty, self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            options.append(.inputNonEmptyValue)
        } else if !canBeEmpty, self.isEmpty {
            options.append(.requiredField)
        } else {
            options.removeAll { $0 == .requiredField }
            options.removeAll { $0 == .inputNonEmptyValue }
            options.removeAll { $0 == .toManySymbols }
        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > maxLength {
            options.append(.toManySymbols)
        }
        
        return options
    }
    
    private struct Regex {
        static let name = #"^[A-Za-z.!@?#"$%&:;() *\+,\/;\-=[\\\]\^_{|}<>\u0400-\u04FF]*$"#
        static let city = "^[a-zA-Z\\u0080-\\u024F\\p{L}]+(?:. |-| |')*([1-9a-zA-Z\\u0080-\\u024F\\p{L}]+(?:. |-| |'))*[a-zA-Z\\u0080-\\u024F\\p{L}]*$"
        static let zip = "^[0-9]{5}(-[0-9]{4})?$"
      //  static let phone = #"^\+[1-9]\d{10,14}$"#
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        static let dateOfBirth = #"^\d{1,2}[/]\d{4}$"#
        static let size = #"^([1-9]|[1-9][0-9]|[1-9][0-9][0-9])$"#
        static let numbers = #"^[0-9]+$"#
    }
    
    private func isValid(regex: String, min: Int = 0, max: Int = 255) -> String? {
        
        if self.count < min {
            return ValidateNameOptions.toFewSymbols.description
        } else if self.count > max {
            return ValidateNameOptions.toManySymbols.description
        } else if self.range(of: regex, options: .regularExpression) != nil {
            return nil
        } else {
            return ValidateCommonOptions.inputNonEmptyValue.description
        }
    }
    
    func isNameValid(canBeEmpty: Bool = false) -> String? {
        
        let minLength = 1
        let maxLength = 32

        let count = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count

        if count < minLength {
            return ValidateNameOptions.toFewSymbols.description
        }

        if count > maxLength {
            return ValidateNameOptions.toManySymbols.description
        }

        if canBeEmpty == false, count == 0 {
            return ValidateNameOptions.toFewSymbols.description
        }

        return nil
    }
    
    func isCityValid() -> String? {
        return self.isValid(regex: Regex.city)
    }
    
    func isZipCodeValid() -> String? {
        return self.isValid(regex: Regex.zip)
    }
        
    func isDynamicFieldValid(regex: String?, min: Int? = 3, max: Int? = 255, canBeEmpty: Bool) -> [ValidateDynamicOptions] {
        
        var options: [ValidateDynamicOptions] = []
        
        if canBeEmpty, !self.isEmpty, self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            options.append(.inputNonEmptyValue)
        } else if !canBeEmpty, !self.isEmpty, self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            options.append(.inputNonEmptyValue)
        } else if !canBeEmpty, self.isEmpty {
            options.append(.requiredField)
        } else {
            options.removeAll { $0 == .requiredField }
            options.removeAll { $0 == .inputNonEmptyValue }
            options.removeAll { $0 == .toManySymbols }
        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > max ?? 255 {
            options.append(.toManySymbols)
        }
        
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count < min ?? 3 {
            options.append(.toFewSymbols)
        }
        
        if let regex = regex, self.range(of: regex, options: .regularExpression) == nil {
            options.append(.inputNonEmptyValue)
        }
        
        return options
    }
    
    func removeSymboldForPhone() -> String {
        var value = self.replacingOccurrences(of: " ", with: "")
        value = value.replacingOccurrences(of: "-", with: "")
        value = value.replacingOccurrences(of: "(", with: "")
        value = value.replacingOccurrences(of: ")", with: "")
        
        return value
    }
}

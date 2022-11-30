//
//  UserStoredObject.swift
//  digitalmedia
//
//  Created by Artem Kirnos on 3/4/19.
//  Copyright © 2019 Zensoft. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

class UserStoredObject: Object, MappableToModel {

    typealias Model = UserModel

    @objc dynamic var id:                       String = ""
    @objc dynamic var email:                    String = ""
    @objc dynamic var passwordSet:              Bool = false
    @objc dynamic var firstName:                String = ""
    @objc dynamic var lastName:                 String = ""
    @objc dynamic var username:                 String = ""
    @objc dynamic var googleLinked:             Bool = false
    @objc dynamic var facebookLinked:           Bool = false
    @objc dynamic var instagramLinked:          Bool = false
    @objc dynamic var photoUrl:                 String = ""
    @objc dynamic var country:                  String = ""
    @objc dynamic var userType:                 String = ""
    @objc dynamic var verificationDocument:     String = ""

    var verificationStatus: VerificationStatus {
        get { return VerificationStatus(rawValue: self.privateVerificationStatus)! }
        set { self.privateVerificationStatus = newValue.rawValue }
    }
    @objc private dynamic var privateVerificationStatus: String = VerificationStatus.none.rawValue

    required convenience init?(map: Map) {
        guard
            map.JSON["email"]                   != nil,
            map.JSON["passwordSet"]             != nil,
            map.JSON["verificationStatus"]      != nil,
            map.JSON["firstName"]               != nil,
            map.JSON["lastName"]                != nil,
            map.JSON["username"]                != nil,
            map.JSON["googleLinked"]            != nil,
            map.JSON["facebookLinked"]          != nil,
            map.JSON["instagramLinked"]         != nil

            else { assertionFailure(); return nil }

        self.init()
    }

    func mapping(map: Map) {
        if map.mappingType == .toJSON {
            self.email                      >>> map["email"]
            self.passwordSet                >>> map["passwordSet"]
            self.verificationStatus         >>> (map["verificationStatus"], VerificationStatus.transformer)
            self.firstName                  >>> map["firstName"]
            self.lastName                   >>> map["lastName"]
            self.username                   >>> map["username"]
            self.googleLinked               >>> map["googleLinked"]
            self.facebookLinked             >>> map["facebookLinked"]
            self.instagramLinked            >>> map["instagramLinked"]
            self.photoUrl                   >>> map["photoUrl"]
            self.country                    >>> map["country"]
            self.userType                   >>> map["userType"]
            self.verificationDocument       >>> map["verificationDocument.image"]
        } else {
            self.email                      <- map["email"]
            self.passwordSet                <- map["passwordSet"]
            self.verificationStatus         <- (map["verificationStatus"], VerificationStatus.transformer)
            self.firstName                  <- map["firstName"]
            self.lastName                   <- map["lastName"]
            self.username                   <- map["username"]
            self.googleLinked               <- map["googleLinked"]
            self.facebookLinked             <- map["facebookLinked"]
            self.instagramLinked            <- map["instagramLinked"]
            self.photoUrl                   <- map["photoUrl"]
            self.country                    <- map["country"]
            self.userType                   <- map["userType"]
            self.verificationDocument       <- map["verificationDocument.image"]
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }
}

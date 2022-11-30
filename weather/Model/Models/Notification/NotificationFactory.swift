//
//  NotificationFactory.swift
//  digitalmedia
//
//  Created by Oleksandr Chyzh on 07.04.2020.
//  Copyright © 2020 Oolla. All rights reserved.
//

import Foundation
import ObjectMapper
import UserNotifications

class NotificationFactory {
    
    private init() {}
    
    static func getPushNotification(notification: UNNotification) -> NotificationModel? {
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else { return nil }
        
        return self.getPushNotification(json: userInfo)
    }
    
    static func getPushNotification(userInfo: [String: Any]) -> NotificationModel? {
        return self.getPushNotification(json: userInfo)
    }
    
    static func getPushNotification(json: [String: Any]) -> NotificationModel? {
    
        var resultDict = [String: Any]()
        
        for (key, value) in json {

            if let stringValue = value as? String,
                let intValue = Int(stringValue) {
                resultDict[key] = intValue
            } else if let stringValue = value as? String, let dict = stringValue.toJson() {
                resultDict[key] = dict
            } else {
                resultDict[key] = value
            }
        }
        
        let obj1 = Mapper<NotificationModel>(context: Context()).map(JSON: resultDict)
        
        return obj1
    }
        
   static func getMobileStatusPush() -> NotificationModel {
        
        let id: Int = Int.random(in: 0..<99999)

        let json = [
            "id":id,
            "type": "mobileStatus",
            "geolocationEnabled": false
        ] as [String : Any]
        
       return Mapper<NotificationModel>(context: Context()).map(JSON: json)!
    }
    
    static func getTrackerLostBLEConnection() -> NotificationModel {
         
         let id: Int = Int.random(in: 0..<99999)

         let json = [
             "id":id,
             "type": "tracker-lost-ble-connection",
             "childId": 157
         ] as [String : Any]
         
        return Mapper<NotificationModel>(context: Context()).map(JSON: json)!
     }
}

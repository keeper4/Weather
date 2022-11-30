//
//  UNUserNotificationCenter+Extension.swift
//  Manzanita
//
//  Created by Oleksandr Chyzh on 08.04.2022.
//  Copyright © 2022 Manzanita. All rights reserved.
//

import UIKit

extension UNUserNotificationCenter {
    
    func test(userInfo: [String: Any]) {
        let title = "test"
        self.sendLocalPush(title: title,
                           categoryIdentifier: "test",
                           userInfo: userInfo)
    }
    
    func newMessageInChat(name: String, chatId: Int, childId: Int) {
        let title = String(format: NSLocalizedString("LocalPush.postedInChat"), name)
        
        let userInfo: [String : Any] = ["chatId": chatId, "childId": childId, "type": "chat-message"]
        self.sendLocalPush(title: title,
                           categoryIdentifier: "chatCategory \(chatId)",
                           userInfo: userInfo)
    }
    
    func handoffInit(userInfo: [String: Any]) {
        let title = userInfo["title"] as? String ?? "Handoff request"
        self.sendLocalPush(title: title,
                           categoryIdentifier: "handoff init",
                           userInfo: userInfo)
    }
    
    private func sendLocalPush(title: String,
                               subtitle: String? = nil,
                               categoryIdentifier: String? = nil,
                               userInfo: [String: Any]? = nil,
                               sound: UNNotificationSound? = UNNotificationSound.default) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = sound
        ///content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground")
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        
        if let userInfo = userInfo {
            content.userInfo = userInfo
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        self.add(request)
    }
}

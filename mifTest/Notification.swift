//
//  Notification.swift
//  mifTest
//
//  Created by Anton Yermakov on 17.06.2018.
//  Copyright © 2018 Anton Yermakov. All rights reserved.
//

import Foundation
import UserNotifications

class Notification {
    
    class func setNotification (title: String, message: String, time : DateComponents, identifier : String){
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: false)
        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nil error")
            }
        })
    }
    
}

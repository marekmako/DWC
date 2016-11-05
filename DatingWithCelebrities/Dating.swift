//
//  Dating.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit
import CoreData


class DatingRepository {
    private let dataController = DataController.shared
    
    func findAll() -> [DatingTypeEntity] {
        let datingTypeFetch = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DatingTypeEntity.self))
        return (try! dataController.managedObjectContext.fetch(datingTypeFetch) as! [DatingTypeEntity]).sorted(by: { $0.id > $1.id })
    }
    
    func findOne(id: Int) -> DatingTypeEntity? {
        return findAll().filter({ $0.id == Int16(id) }).first
    }
}


class DatingResolver {
    
    func accept(with celebrity: CelebrityEntity, dating: DatingTypeEntity, time: Date) -> Bool {
        let me = Me()
        
        if me.coin < Int(dating.price) {
            return false
            
        } else {
            registerForUserNotification(in: UIApplication.shared)
            
            let notificationId = Int16(arc4random_uniform(UInt32(Int16.max)))
            let notification = UILocalNotification()
            notification.alertTitle = "👉 \(celebrity.name) missing you 👈"
            notification.alertBody = "Hello it's time to \(dating.name) with \(celebrity.name) 😘"
            notification.fireDate = time
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["id" : notificationId]
            UIApplication.shared.scheduleLocalNotification(notification)
            
            me.addDatingWithCelebrity(celebrity: celebrity, dating: dating, time: time, notificationId: notificationId)
            me.remove(coin: Int(dating.price))
            return true
        }
    }
}

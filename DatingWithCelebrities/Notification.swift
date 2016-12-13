//
//  Notification.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 09/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit


let kLocalNotificationId = "local_notification_id"


class LocalNotification {
    
    private let kDatingYesAction = "yes_action"
    private let kDatingNoAction = "no_action"
    let kDatingCategory = "dating_local_notification"
    
    fileprivate let userDefaults = UserDefaults.standard
    
    fileprivate let me = Me()
    
    static let shared = LocalNotification()
    
    
    private func registerForUserNotification(in application: UIApplication) {
        // rande notifikacie
        let okAction = UIMutableUserNotificationAction()
        okAction.title = "YES, go to dating"
        okAction.identifier = kDatingYesAction
        okAction.activationMode = .foreground
        okAction.isAuthenticationRequired = true
        okAction.isDestructive = false
        
        let cancelAction = UIMutableUserNotificationAction()
        cancelAction.title = "Refuse"
        cancelAction.identifier = kDatingNoAction
        cancelAction.activationMode = .background
        cancelAction.isAuthenticationRequired = false
        cancelAction.isDestructive = true
        
        let datingLocalNotificationCategory = UIMutableUserNotificationCategory()
        datingLocalNotificationCategory.identifier = kDatingCategory
        datingLocalNotificationCategory.setActions([okAction, cancelAction], for: .default)
        datingLocalNotificationCategory.setActions([okAction, cancelAction], for: .minimal)
        
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                  categories: Set([datingLocalNotificationCategory]))
        application.registerUserNotificationSettings(settings)
        
        userDefaults.set(true, forKey: "checkUserNotificationOnStartup")
    }
        
    func checkUserNotificationOnStartup(_ application: UIApplication) {
        if userDefaults.bool(forKey: "checkUserNotificationOnStartup") {
            registerForUserNotification(in: application)
        }
    }
    
    func handleRecievedDatingWhenAppActive(notificationId: Int) {
        guard let datingWithCelebrity = me.findDatingWithCelebrity(byNotificationId: notificationId) else {
            return
        }
        
        let currentVC = UIApplication.shared.keyWindow?.rootViewController
        
        let alertVC = UIAlertController(title: "It's time to\n \(datingWithCelebrity.datingType!.name!)\n with\n \(datingWithCelebrity.celebrity!.name!)!", message: "Are Your Ready?", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Yes, go to datting", style: .default, handler: { (action: UIAlertAction) in
            let datingVC = currentVC?.storyboard?.instantiateViewController(withIdentifier: String(describing: DatingWithCelebrityViewController.self)) as! DatingWithCelebrityViewController
            
            datingVC.datingWithCelebrity = datingWithCelebrity
            currentVC?.present(datingVC, animated: true, completion: nil)
        }))
        alertVC.addAction(UIAlertAction(title: "Refuse", style: .destructive, handler: { (action) in
            self.me.remove(dating: datingWithCelebrity)
            
            if let navigationVC = currentVC as? UINavigationController, let myDatingsVC = navigationVC.topViewController as? MyDatingListViewController {
                myDatingsVC.datingsTable.reloadData()
            }
        }))
        
        currentVC?.present(alertVC, animated: true, completion: nil)
    }
    
    func handleRecievedDatingWhenAppInactive(notification: UILocalNotification) {
        userDefaults.set(true, forKey: "has_dating")
        userDefaults.set(notification.userInfo![kLocalNotificationId], forKey: "dating_notification_id")
    }
    
    func tryHandleDatingWhenViewControllerDidAppear() {
        userDefaults.set(false, forKey: "has_dating")
        let notificationId = userDefaults.integer(forKey: "dating_notification_id")
        handleRecievedDatingWhenAppActive(notificationId: notificationId)
    }
    
    func handleDatingAction(identifier: String, notification: UILocalNotification)  {
        guard let datingWithCelebrity = me.findDatingWithCelebrity(byNotificationId: notification.userInfo![kLocalNotificationId] as! Int) else {
            return
        }
        
        switch identifier {
            
        case kDatingYesAction:
            let currentVC = UIApplication.shared.keyWindow?.rootViewController
            let datingVC = currentVC?.storyboard?.instantiateViewController(withIdentifier: String(describing: DatingWithCelebrityViewController.self)) as! DatingWithCelebrityViewController
            datingVC.datingWithCelebrity = datingWithCelebrity
            currentVC?.present(datingVC, animated: true, completion: nil)
            
            break
            
        case kDatingNoAction:
            me.remove(dating: datingWithCelebrity)
            
            break
            
        default:
            return
        }
    }
    
    // return notification id
    func registerLocalNotificationForDating(with celebrity: CelebrityEntity, datingType: DatingTypeEntity, at time: Date) -> Int16 {
        
        registerForUserNotification(in: UIApplication.shared)
        
        let notificationId = Int16(arc4random_uniform(UInt32(Int16.max)))
        let notification = UILocalNotification()
        notification.alertTitle = "It's time to \(datingType.name!) with \(celebrity.name!)!"
        notification.alertBody = "Are You Ready?"
        notification.fireDate = time
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = [kLocalNotificationId : notificationId]
        notification.category = kDatingCategory
        UIApplication.shared.scheduleLocalNotification(notification)
        
        return notificationId
    }
}

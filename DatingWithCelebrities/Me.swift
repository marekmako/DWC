//
//  Me.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit
import CoreData


class Me {
    
    private let userDefaults = UserDefaults.standard
    
    private let dataController = DataController.shared
    
    private let kCoin = "coin"
    
    var coin: Int {
        get {
            return userDefaults.integer(forKey: kCoin)
        }
        set {
            userDefaults.set(newValue, forKey: kCoin)
        }
    }
    
    var datings: [DatingWithCelebrityEntity] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DatingWithCelebrityEntity.self))
        return try! dataController.managedObjectContext.fetch(request) as! [DatingWithCelebrityEntity]
    }
    
    func addDatingWithCelebrity(celebrity: CelebrityEntity, dating: DatingTypeEntity, time: Date, notificationId: Int16) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: DatingWithCelebrityEntity.self), into: dataController.managedObjectContext) as! DatingWithCelebrityEntity
        entity.celebrity = celebrity
        entity.datingType = dating
        entity.time = time as NSDate?
        entity.notificationId = notificationId
        
        try! dataController.managedObjectContext.save()
    }
    
    func findDatingWithCelebrity(byNotificationId: Int) -> DatingWithCelebrityEntity? {
        let index = datings.index { (entity: DatingWithCelebrityEntity) -> Bool in
            return entity.notificationId == Int16(byNotificationId)
        }
        guard let datingIndex = index else {
            return nil
        }
        
        return datings[datingIndex]
    }
    
    func remove(dating: DatingWithCelebrityEntity)  {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: DatingWithCelebrityEntity.self))
        request.predicate = NSPredicate(format: "(notificationId = %@) and (time = %@) and (celebrity.id = %@) and (datingType.id = %@)",
                                        argumentArray: [dating.notificationId, dating.time!, dating.celebrity!.id, dating.datingType!.id])
        let entity = try! dataController.managedObjectContext.fetch(request).first as! DatingWithCelebrityEntity
        dataController.managedObjectContext.delete(entity)
        try! dataController.managedObjectContext.save()
    }
    
    func add(coin amount: Int) {
        coin += amount
    }
    
    func remove(coin amount: Int) {
        coin -= amount
    }
}


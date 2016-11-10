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



class AboutMeViewController: BaseViewController {
    
}


// TODO: Vytvorit vlastny VC
class MyDatingListViewController: BaseViewController {
    
    fileprivate let MY_DATING_TABLE_CELL_NAME = "my_dating_table_cell"
    
    fileprivate let me = Me()
    
    fileprivate var datingTableData: [DatingWithCelebrityEntity] {
        return me.datings
    }
    
    @IBOutlet weak var datingsTable: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissDatingWithCelebrityVC), name: DatingWithCelebrityViewController.DismissedNotificationName, object: nil)
        
        datingsTable.dataSource = self
        datingsTable.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    /// pretoze data tabulky mozu byt zmene notifikaciami
    func didBecomeActive() {
        datingsTable.reloadData()
    }
    
    /// DatingWithCelebrityVC zmaze data v mojich datingoch je potrebne refreshunt tabulku
    func didDismissDatingWithCelebrityVC() {
        datingsTable.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        datingsTable.setEditing(editing, animated: animated)
    }
}

// MARK: UITableViewDataSource
extension MyDatingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datingTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MY_DATING_TABLE_CELL_NAME) as! MyDatingListTableViewCell
        
        cell.datingWithSelebrityEntity = datingTableData[indexPath.row]
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MyDatingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            me.remove(dating: datingTableData[indexPath.row])
            tableView.reloadData()
            
            break
            
        default:
            break
        }
    }
}



class MyDatingListTableViewCell: UITableViewCell {
    
    private let celebrityRepo = CelebrityRepository()
    
    var datingWithSelebrityEntity: DatingWithCelebrityEntity? {
        didSet {
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            timeFormatter.dateStyle = .short
            let time = timeFormatter.string(from: datingWithSelebrityEntity!.time as! Date)
            dateTimeLabel.text = time
            
            let datingTypeName = datingWithSelebrityEntity!.datingType?.name
            dateTypeLabel.text = datingTypeName
            
            let celebrity = datingWithSelebrityEntity!.celebrity
            celebrityImageView.image = celebrityRepo.findPhoto(for: celebrity!, type: .Select)
            
            celebrityNameLabel.text = celebrity?.name
        }
    }
    
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateTypeLabel: UILabel!
    @IBOutlet weak var celebrityImageView: UIImageView!
    @IBOutlet weak var celebrityNameLabel: UILabel!
}

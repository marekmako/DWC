//
//  Me.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit




class Me {
    
    private let userDefaults = UserDefaults.standard
    
    private let kCoin = "coin"
    
    var coin: Int {
        get {
            return userDefaults.integer(forKey: kCoin)
        }
        set {
            userDefaults.set(newValue, forKey: kCoin)
        }
    }
    
    private let kDatings = "datings"
    
    private(set) var datings: [DatingWithCelebrityEntity] {
        get {
            if let data = userDefaults.data(forKey: kDatings), let theDatings = NSKeyedUnarchiver.unarchiveObject(with: data) as? [DatingWithCelebrityEntity] {
                return theDatings
                
            } else {
                return [DatingWithCelebrityEntity]()
            }
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            userDefaults.set(data, forKey: kDatings)
        }
    }
    
    func add(dating: DatingWithCelebrityEntity) {
        datings.append(dating)
    }
    
    func remove(dating: DatingWithCelebrityEntity)  {
        let index = datings.index { (item: DatingWithCelebrityEntity) -> Bool in
            return dating.celebrity.id == item.celebrity.id &&
                dating.dating.id == item.dating.id &&
                dating.time == item.time
        }
        
        datings.remove(at: index!)
    }
    
    func removeAllDatings() {
        datings = [DatingWithCelebrityEntity]()
    }
    
    func add(coin amount: Int) {
        coin += amount
    }
    
    func remove(coin amount: Int) {
        coin -= amount
    }
}



class AboutMeViewController: UIViewController {
    
}



class MyDatingListViewController: UIViewController {
    
    fileprivate let MY_DATING_TABLE_CELL_NAME = "my_dating_table_cell"
    
    fileprivate let me = Me()
    
    fileprivate var datingTableData: [DatingWithCelebrityEntity] {
        return me.datings
    }
    
    @IBOutlet weak var datingsTable: UITableView!
    
    override func viewDidLoad() {
        datingsTable.dataSource = self
        datingsTable.delegate = self
        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            let time = timeFormatter.string(from: datingWithSelebrityEntity!.time)
            dateTimeLabel.text = time
            
            let datingTypeName = datingWithSelebrityEntity!.dating.name
            dateTypeLabel.text = datingTypeName
            
            let celebrity = datingWithSelebrityEntity!.celebrity
            celebrityImageView.image = celebrityRepo.findPhoto(for: celebrity, type: .Select)
            
            celebrityNameLabel.text = celebrity.name
        }
    }
    
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateTypeLabel: UILabel!
    @IBOutlet weak var celebrityImageView: UIImageView!
    @IBOutlet weak var celebrityNameLabel: UILabel!
}

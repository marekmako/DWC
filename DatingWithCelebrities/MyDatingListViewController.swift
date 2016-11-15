//
//  MyDatingListViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 15/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class MyDatingListViewController: BaseViewController {
    
    fileprivate let MY_DATING_TABLE_CELL_NAME = "my_dating_table_cell"
    
    fileprivate let me = Me()
    
    fileprivate var datingTableData: [DatingWithCelebrityEntity] {
        return me.datings
    }
    
    @IBOutlet weak var datingsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didDismissDatingWithCelebrityVC), name: DatingWithCelebrityViewController.DismissedNotificationName, object: nil)
        
        datingsTable.dataSource = self
        datingsTable.delegate = self
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: DatingWithCelebrityViewController.DismissedNotificationName, object: nil)
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


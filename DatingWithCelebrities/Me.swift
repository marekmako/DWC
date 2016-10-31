//
//  Me.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit


class AboutMeViewController: UIViewController {
    
    fileprivate let TABLE_VIEW_CELL = "my_dating_table_cell"
    
    fileprivate let myDatingData = [String](repeating: "", count: 5)
    
    @IBOutlet weak var myDatingTableView: UITableView!
    
    override func viewDidLoad() {
        myDatingTableView.dataSource = self
    }
}


extension AboutMeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDatingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_VIEW_CELL, for: indexPath)
        return cell
    }
}

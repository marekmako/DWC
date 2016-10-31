//
//  Celebrity.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



class CelebritySelectViewController: UIViewController {
    
    fileprivate let TABLE_CELL_NAME = "celebrity_table_cell"
    
    @IBOutlet weak var celebrityTableView: UITableView!
    
    fileprivate let celebrityData = [String](repeating: "", count: 5)
    
    override func viewDidLoad() {
        celebrityTableView.dataSource = self
    }
}



// MARK: UITableViewDataSource
extension CelebritySelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrityData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLE_CELL_NAME, for: indexPath)
        return cell
    }
}



class CelebrityViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let datingVC = segue.destination as? DatingViewController {
            datingVC.datingNameFromSegue = segue.identifier
        }
    }
}

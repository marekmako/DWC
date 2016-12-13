//
//  CelebritySelectViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



class CelebritySelectViewController: BaseViewController {

    fileprivate let celebrityRepository = CelebrityRepository()
    
    @IBOutlet weak var celebrityTableView: UITableView!
    
    override func viewDidLoad() {
        celebrityTableView.dataSource = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let celebrityCell = sender as? CelebritySelectTableViewCell, let datingVC = segue.destination as? DatingInvitationViewController {
            datingVC.celebrity = celebrityCell.celebrity
        }
    }
    
    @IBAction func unwindToCelebritySelectViewController(segue: UIStoryboardSegue) {}

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK: UITableViewDataSource
extension CelebritySelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrityRepository.findAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CelebritySelectTableViewCell.self)) as! CelebritySelectTableViewCell
        
        let celebrity = celebrityRepository.findAll()[indexPath.row]
        
        cell.celebrity = celebrity
        
        return cell
    }
}

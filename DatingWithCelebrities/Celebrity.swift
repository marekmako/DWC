//
//  Celebrity.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit


@objc class CelebrityEntity: NSObject, NSCoding {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = Int(aDecoder.decodeInt32(forKey: "id"))
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
}



enum PhotoType: String {
    case Select = "select", Detail = "detail"
}



class CelebrityRepository {
    
    private let all: [CelebrityEntity] = {
        var list = [CelebrityEntity]()
        
        guard  let path = Bundle.main.path(forResource: "Celebrity", ofType: "plist") else {
            fatalError("Nenajdeny fajl Celebrity.plist")
        }
        guard let data = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else {
            fatalError("Neviem precitat data")
        }
        
        for row in data {
            list.append(CelebrityEntity(id: row["id"] as! Int,
                                        name: row["name"] as! String))
        }
        
        return list
    }()
    
    func findAll() -> [CelebrityEntity] {
        return all
    }
    
    func findPhoto(for celebrity: CelebrityEntity, type: PhotoType) -> UIImage? {
        return UIImage(named: "\(celebrity.id)-\(type.rawValue)")
    }
}



class CelebritySelectViewController: UIViewController {
    
    fileprivate let celebrityRepository = CelebrityRepository()

    @IBOutlet weak var celebrityTableView: UITableView!
    
    override func viewDidLoad() {
        celebrityTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let celebrityCell = sender as? CelebritySelectTableCell, let datingVC = segue.destination as? DatingInvitationViewController {
            datingVC.celebrity = celebrityCell.celebrity
        }
    }
    
    @IBAction func unwindToCelebritySelectViewController(segue: UIStoryboardSegue) {}
}



// MARK: UITableViewDataSource
extension CelebritySelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return celebrityRepository.findAll().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CelebritySelectTableCell.NAME, for: indexPath) as! CelebritySelectTableCell
        
        let celebrity = celebrityRepository.findAll()[indexPath.row]
        
        cell.celebrity = celebrity
        
        return cell
    }
}



class CelebritySelectTableCell: UITableViewCell {
    
    private let celebrityRepo = CelebrityRepository()
    
    fileprivate static let NAME = "celebrity_table_cell"
    
    var celebrity: CelebrityEntity? {
        didSet {
            celebrityNameLabel.text = celebrity?.name
            celebrityImage.image = celebrityRepo.findPhoto(for: celebrity!, type: .Select)
        }
    }
    
    @IBOutlet weak var celebrityNameLabel: UILabel!
    
    @IBOutlet weak var celebrityImage: UIImageView!
    
}





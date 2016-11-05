//
//  Celebrity.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit
import CoreData



enum PhotoType: String {
    case Select = "select", Detail = "detail"
}


class CelebrityRepository {
    private let dataController = DataController.shared
    
    func findAll() -> [CelebrityEntity] {
        let celebrityRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CelebrityEntity.self))
        return (try! dataController.managedObjectContext.fetch(celebrityRequest) as! [CelebrityEntity]).sorted(by: { $0.id > $1.id })
    }
    
    func findPhoto(for celebrity: CelebrityEntity, type: PhotoType) -> UIImage? {
        return UIImage(named: "\(celebrity.id)-\(type.rawValue)")
    }
}

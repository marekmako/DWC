//
//  MyDatingListTableViewCell.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 15/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

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

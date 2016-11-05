//
//  CelebritySelectTableViewCell.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class CelebritySelectTableViewCell: UITableViewCell {
    
    private let celebrityRepo = CelebrityRepository()
    
    var celebrity: CelebrityEntity? {
        didSet {
            celebrityNameLabel.text = celebrity?.name
            celebrityImage.image = celebrityRepo.findPhoto(for: celebrity!, type: .Select)
        }
    }
    
    @IBOutlet weak var celebrityNameLabel: UILabel!
    
    @IBOutlet weak var celebrityImage: UIImageView!

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}

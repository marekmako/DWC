//
//  Dating.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



class DatingViewController: UIViewController {
    
    var datingNameFromSegue: String?
    
    @IBOutlet weak var datingTypeLabel: UILabel!
    
    override func viewDidLoad() {
        datingTypeLabel.text = datingNameFromSegue
        
        registerForUserNotification(in: UIApplication.shared)
    }
}

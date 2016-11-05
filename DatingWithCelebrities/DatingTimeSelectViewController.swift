//
//  DatingTimeSelectViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class DatingTimeSelectViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        timePicker.minimumDate = Date()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

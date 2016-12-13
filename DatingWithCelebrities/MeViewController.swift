//
//  MeViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {
    
    private let me = Me()
    
    @IBOutlet weak var coinLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coinLabel.text = String(me.coin)
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

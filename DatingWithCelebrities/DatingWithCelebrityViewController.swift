//
//  DatingWithCelebrityViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 09/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class DatingWithCelebrityViewController: UIViewController {
    
    static let DismissedNotificationName = Notification.Name("DatingWithCelebrityViewControllerDissmised")
    
    private let me = Me()
    
    var datingWithCelebrity: DatingWithCelebrityEntity?

    @IBAction func onCancel() {
        me.remove(dating: datingWithCelebrity!)
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: DatingWithCelebrityViewController.DismissedNotificationName, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

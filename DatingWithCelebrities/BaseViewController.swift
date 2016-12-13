//
//  BaseViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 10/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LocalNotification.shared.tryHandleDatingWhenViewControllerDidAppear()
    }
}

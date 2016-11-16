//
//  DatingWithCelebrityViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 09/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class DatingWithCelebrityViewController: BaseViewController {
    
    static let DismissedNotificationName = Notification.Name("DatingWithCelebrityViewControllerDissmised")
    
    private let me = Me()
    
    /// from segue
    var datingWithCelebrity: DatingWithCelebrityEntity?

    @IBAction func onCancel() {
        me.remove(dating: datingWithCelebrity!)
        
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: DatingWithCelebrityViewController.DismissedNotificationName, object: nil)
        })
    }
    
    // MARK: FOTOALBUM
    private(set) var photos = [UIImage]()
    
    @IBOutlet weak var currPhotoImageView: UIImageView!

    @IBAction func onBackwardPhotoAction() {
        let index = photos.index(of: currPhotoImageView.image!)!
        if index > 0 {
            let prewIndex = index - 1
            
            UIView.animate(withDuration: 1, animations: {
                self.currPhotoImageView.alpha = 0
                self.currPhotoImageView.image = self.photos[prewIndex]
                self.currPhotoImageView.alpha = 1
            })
        }
    }
    
    @IBAction func onForwardPhotoAction() {
        let index = photos.index(of: currPhotoImageView.image!)!
        if index < photos.count - 1 {
            let nextIndex = index + 1
            
            UIView.animate(withDuration: 1, animations: {
                self.currPhotoImageView.alpha = 0
                self.currPhotoImageView.image = self.photos[nextIndex]
                self.currPhotoImageView.alpha = 1
            })
        }
    }
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard nil != datingWithCelebrity else {
            fatalError("datingWithCelebrity naplnit zo segue")
        }
        
        photos.append(UIImage(named: "\(datingWithCelebrity!.celebrity!.id)-detail")!)
        photos.append(UIImage(named: "\(datingWithCelebrity!.celebrity!.id)-love")!)
        photos.append(UIImage(named: "\(datingWithCelebrity!.celebrity!.id)-select")!)
        
        currPhotoImageView.image = photos.first
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

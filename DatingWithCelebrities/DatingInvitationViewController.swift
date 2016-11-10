//
//  DatingInvitationViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



class DatingInvitationViewController: BaseViewController {
    
    private let celebrityRepo = CelebrityRepository()
    
    fileprivate let datingRepo = DatingRepository()
    
    var selectedDatingType: DatingTypeEntity? {
        didSet {
            datingTypeButton.setTitle(selectedDatingType?.name, for: .normal)
        }
    }
    
    var selectedDatingTime: Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let time = formatter.string(from: selectedDatingTime!)
            datingTimeButton.setTitle(time, for: .normal)
        }
    }
    
    @IBOutlet weak var celebrityImageView: UIImageView!
    @IBOutlet weak var celebrityNameLabel: UILabel!
    @IBOutlet weak var datingTypeButton: UIButton!
    @IBOutlet weak var datingTimeButton: UIButton!
    
    @IBAction func onInvite() {
        guard nil != selectedDatingTime && nil != selectedDatingType else {
            let alertVC = UIAlertController(title: "Jejda lasko jedina 💩", message: "nevyplnene dating type alebo time", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
            present(alertVC, animated: true, completion: nil)
            
            return
        }
        
        inviteAndPresentView()
    }
    
    /// from segue
    var celebrity: CelebrityEntity?
    
    override func viewDidLoad() {
        guard nil != celebrity else {
            fatalError("premenna celebrity musi byt nastavena zo segue")
        }
        
        celebrityNameLabel.text = celebrity?.name
        celebrityImageView.image = celebrityRepo.findPhoto(for: celebrity!, type: .Detail)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToDatingInvitationViewController(segue: UIStoryboardSegue) {
        if let selectDatingTypeVC = segue.source as? DatingTypeSelectViewController {
            selectedDatingType = selectDatingTypeVC.selectedDatingEntity
            
        } else if let selectTimeVC = segue.source as? DatingTimeSelectViewController {
            selectedDatingTime = selectTimeVC.timePicker.date
        }
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: Actions support
extension DatingInvitationViewController {
    
    fileprivate func inviteAndPresentView() {
        guard let selectedDatingEntity = datingRepo.findOne(id: Int(selectedDatingType!.id)) else {
            fatalError("Nenajdena dating entita")
        }
        
        let isDatingAccepted = DatingResolver().accept(with: celebrity!, dating: selectedDatingEntity, time: selectedDatingTime!)
        
        // TODO: message + actions
        let alertVC = UIAlertController(title: nil, message: "TODO: message + actions", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        if isDatingAccepted {
            alertVC.title = "ACCEPTED!"
            
        } else {
            alertVC.title = "REJECTED!"
        }
        
        present(alertVC, animated: true, completion: nil)
    }
}

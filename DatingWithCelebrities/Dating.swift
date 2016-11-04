//
//  Dating.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 30/10/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit



@objc class DatingEntity: NSObject, NSCoding {
    let id: Int
    let name: String
    let price: Int
    
    init(id: Int, name: String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = Int(aDecoder.decodeInt32(forKey: "id"))
        name = aDecoder.decodeObject(forKey: "name") as! String
        price = Int(aDecoder.decodeInt32(forKey: "price"))
    }
}



@objc class DatingWithCelebrityEntity: NSObject, NSCoding {
    let id: Int
    let celebrity: CelebrityEntity
    let dating: DatingEntity
    let time: Date
    let notificationId: UInt32
    
    init(id: Int = 0, celebrity: CelebrityEntity, dating: DatingEntity, time: Date, notificationId: UInt32) {
        self.id = id
        self.celebrity = celebrity
        self.dating = dating
        self.time = time
        self.notificationId = notificationId
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = Int(aDecoder.decodeInt32(forKey: "id"))
        celebrity = aDecoder.decodeObject(forKey: "celebrity") as! CelebrityEntity
        dating = aDecoder.decodeObject(forKey: "dating") as! DatingEntity
        time = aDecoder.decodeObject(forKey: "time") as! Date
        notificationId = aDecoder.decodeObject(forKey: "notificationId") as! UInt32
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(celebrity, forKey: "celebrity")
        aCoder.encode(dating, forKey: "dating")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(notificationId, forKey: "notificationId")
    }
}



class DatingRepository {
    
    private let all: [DatingEntity] = {
        var list = [DatingEntity]()
        
        guard  let path = Bundle.main.path(forResource: "Dating", ofType: "plist") else {
            fatalError("Nenajdeny fajl Dating.plist")
        }
        guard let data = NSArray(contentsOfFile: path) as? [[String : AnyObject]] else {
            fatalError("Neviem precitat data")
        }
        
        for row in data {
            list.append(DatingEntity(id: row["id"] as! Int,
                                     name: row["name"] as! String,
                                     price: row["price"] as! Int))
        }
        
        return list
    }()
    
    func findAll() -> [DatingEntity] {
        return all
    }
    
    func findOne(id: Int) -> DatingEntity? {
        return all.filter({ (entity: DatingEntity) -> Bool in
            return id == entity.id
        }).first
    }
}


class DatingResolver {
    
    func accept(with celebrity: CelebrityEntity, dating: DatingEntity, time: Date) -> Bool {
        let me = Me()
        
        if me.coin < dating.price {
            return false
            
        } else {
            registerForUserNotification(in: UIApplication.shared)
            
            let notificationId = arc4random_uniform(UInt32.max)
            let notification = UILocalNotification()
            notification.alertTitle = "👉 \(celebrity.name) missing you 👈"
            notification.alertBody = "Hello it's time to \(dating.name) with \(celebrity.name) 😘"
            notification.fireDate = time
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["id" : notificationId]
            UIApplication.shared.scheduleLocalNotification(notification)
            
            me.add(dating: DatingWithCelebrityEntity(celebrity: celebrity, dating: dating, time: time, notificationId: notificationId))
            me.remove(coin: dating.price)
            return true
        }
    }
}


class DatingInvitationViewController: UIViewController {
    
    fileprivate let DATING_INVITATION_OK_VC_NAME = "dating_invitation_ok"
    fileprivate let DATING_INVITATION_NOK_VC_NAME = "dating_invitation_nok"
    
    private let celebrityRepo = CelebrityRepository()
    
    fileprivate let datingRepo = DatingRepository()
    
    var selectedDatingType: DatingEntity? {
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
    
    /// from segue
    var celebrity: CelebrityEntity?
    
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
    
    override func viewDidLoad() {
        celebrityNameLabel.text = celebrity?.name
        celebrityImageView.image = celebrityRepo.findPhoto(for: celebrity!, type: .Detail)
    }
    
    @IBAction func unwindToDatingInvitationViewController(segue: UIStoryboardSegue) {
        if let selectDatingTypeVC = segue.source as? SelectDatingTypeViewController {
            selectedDatingType = selectDatingTypeVC.selectedDatingEntity
            
        } else if let selectTimeVC = segue.source as? SelectDatingTimeViewController {
            selectedDatingTime = selectTimeVC.timePicker.date
        }
    }
}


// MARK: Action
extension DatingInvitationViewController {
    
    fileprivate func inviteAndPresentView() {
        guard let selectedDatingEntity = datingRepo.findOne(id: selectedDatingType!.id) else {
            fatalError("Nenajdena dating entita")
        }
        
        let isDatingAccepted = DatingResolver().accept(with: celebrity!, dating: selectedDatingEntity, time: selectedDatingTime!)
        
        if isDatingAccepted {
            let vc = storyboard?.instantiateViewController(withIdentifier: DATING_INVITATION_OK_VC_NAME)
            present(vc!, animated: true, completion: nil)
            
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: DATING_INVITATION_NOK_VC_NAME)
            present(vc!, animated: true, completion: nil)
        }
    }
}



class SelectDatingTypeViewController: UIViewController {
    
    fileprivate let datingRepo = DatingRepository()
    
    fileprivate let dateTypePickerData: [DatingEntity] = {
        let repository = DatingRepository()
        return repository.findAll()
    }()
    
    var selectedDatingEntity: DatingEntity {
        get {
            let selectedIndex = dateTypePicker.selectedRow(inComponent: 0)
            let entityId = dateTypePickerData[selectedIndex].id
            return datingRepo.findOne(id: entityId)!
        }
    }
    
    @IBOutlet weak var dateTypePicker: UIPickerView!
    
    override func viewDidLoad() {
        dateTypePicker.delegate = self
        dateTypePicker.dataSource = self
    }
}


// MARK: UIPickerViewDataSource
extension SelectDatingTypeViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateTypePickerData.count
    }
}

// MARK: UIPickerViewDelegate
extension SelectDatingTypeViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateTypePickerData[row].name
    }
}



class SelectDatingTimeViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!

    override func viewDidLoad() {
        timePicker.minimumDate = Date()
    }
}



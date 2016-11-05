//
//  DatingTypeSelectViewController.swift
//  DatingWithCelebrities
//
//  Created by Marek Mako on 05/11/2016.
//  Copyright © 2016 Marek Mako. All rights reserved.
//

import UIKit

class DatingTypeSelectViewController: UIViewController {

    fileprivate let datingRepo = DatingRepository()
    
    fileprivate let dateTypePickerData: [DatingTypeEntity] = {
        let repository = DatingRepository()
        return repository.findAll()
    }()
    
    var selectedDatingEntity: DatingTypeEntity {
        get {
            let selectedIndex = dateTypePicker.selectedRow(inComponent: 0)
            let entityId = dateTypePickerData[selectedIndex].id
            return datingRepo.findOne(id: Int(entityId))!
        }
    }
    
    @IBOutlet weak var dateTypePicker: UIPickerView!
    
    override func viewDidLoad() {
        dateTypePicker.delegate = self
        dateTypePicker.dataSource = self
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

// MARK: UIPickerViewDataSource
extension DatingTypeSelectViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateTypePickerData.count
    }
}

// MARK: UIPickerViewDelegate
extension DatingTypeSelectViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateTypePickerData[row].name
    }
}

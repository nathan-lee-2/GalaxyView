//
//  SettingsViewController.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    @IBOutlet weak var nightModeLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var yearsBetweenLabel: UILabel!
    @IBOutlet weak var nightModeSwitch: UISwitch!
    var nightModeOn = Bool()
    @IBOutlet weak var notificationsSwitch: UISwitch!
    var notificationsOn = Bool()
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var beginningYearIndex = 15
    var endingYearIndex = 23
    var alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.selectRow(beginningYearIndex, inComponent: 0, animated: false)
        yearPicker.selectRow(endingYearIndex, inComponent: 1, animated: false)
        nightModeSwitch.setOn(nightModeOn, animated: false)
        notificationsSwitch.setOn(notificationsOn, animated: false)
        //notifications are disabled for now
        notificationsSwitch.isEnabled = false
        if nightModeOn {
            view.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
            nightModeLabel.textColor = UIColor.white
            notificationsLabel.textColor = UIColor.white
            yearsBetweenLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            nightModeLabel.textColor = UIColor.black
            notificationsLabel.textColor = UIColor.black
            yearsBetweenLabel.textColor = UIColor.black
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            let destination = segue.destination as! ViewController
            destination.nightMode = nightModeSwitch.isOn
            destination.notificationsOn = notificationsSwitch.isOn
            beginningYearIndex = yearPicker.selectedRow(inComponent: 0)
            destination.beginningYearIndex = self.beginningYearIndex
            endingYearIndex = yearPicker.selectedRow(inComponent: 1)
            destination.endingYearIndex = self.endingYearIndex
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restoreDefaultsPressed(_ sender: UIButton) {
        nightModeSwitch.setOn(true, animated: true)
        notificationsSwitch.setOn(false, animated: true)
        yearPicker.selectRow(15, inComponent: 0, animated: true)
        yearPicker.selectRow(23, inComponent: 1, animated: true)
    }
    
    //picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleYears.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let yearsArray = [possibleYears, possibleYears]
        return yearsArray[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.selectedRow(inComponent: 0) > pickerView.selectedRow(inComponent: 1){
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
        
    }
}

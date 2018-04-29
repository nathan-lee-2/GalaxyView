//
//  SettingsViewController.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var enableSoundSwitch: UISwitch!
    @IBOutlet weak var slideshowModeSwitch: UISwitch!
    @IBOutlet weak var yearPicker: UIPickerView!
    var beginningYearIndex = 15
    var endingYearIndex = 23
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.selectRow(beginningYearIndex, inComponent: 0, animated: false)
        yearPicker.selectRow(endingYearIndex, inComponent: 1, animated: false)
        enableSoundSwitch.isOn = true
        slideshowModeSwitch.isOn = false
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yearPicker.selectRow(beginningYearIndex, inComponent: 0, animated: false)
        yearPicker.selectRow(endingYearIndex, inComponent: 1, animated: false)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            let destination = segue.destination as! ViewController
            destination.soundEnabled = enableSoundSwitch.isOn
            destination.slideshowModeEnabled = slideshowModeSwitch.isOn
            beginningYearIndex = yearPicker.selectedRow(inComponent: 0)
            destination.beginningYearIndex = self.beginningYearIndex
            endingYearIndex = yearPicker.selectedRow(inComponent: 1)
            destination.endingYearIndex = self.endingYearIndex
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func soundSwitchChanged(_ sender: UISwitch) {
    }
    @IBAction func slideshowSwitchChanged(_ sender: UISwitch) {
    }
    
    @IBAction func restoreDefaultsPressed(_ sender: UIButton) {
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
}

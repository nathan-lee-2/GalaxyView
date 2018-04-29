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
    let possibleYears = ["1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.selectRow(15, inComponent: 0, animated: false)
        yearPicker.selectRow(possibleYears.count-1, inComponent: 1, animated: false)
        slideshowModeSwitch.isOn = false
        
    }
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
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
}

//
//  ViewController.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spaceImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    var apod = APOD()
    var prevDate = ""
    var nextDate = ""
    var beginningYearIndex = Int()
    var endingYearIndex = Int()
    var soundEnabled = true
    var slideshowModeEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        beginningYearIndex = 15
        endingYearIndex = possibleYears.count - 1
        newAPOD()
        prevButton.isHidden = true
    }
    
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        nextDate = apod.date
        apod.date = prevDate
        prevButton.isHidden = true
        newAPOD()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        prevButton.isHidden = false
        prevDate = apod.date
        if nextDate == "" {
            apod.RandomDate(beginningYear: Int(possibleYears[beginningYearIndex])!, endingYear: Int(possibleYears[endingYearIndex])!)
        }else {
            apod.date = nextDate
            nextDate = ""
        }
        newAPOD()
    }
    
    func newAPOD() {
        apod.setAPOD {
            self.titleLabel.text = self.apod.title
            self.spaceImage.downloadedFrom(link: self.apod.imageURL)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInformationPressed" {
            let destination = segue.destination as! InfoViewController
            destination.apod = self.apod
        }
        else {
            let destNavigationController = segue.destination as! UINavigationController
            let targetVC = destNavigationController.topViewController as! SettingsViewController
            targetVC.beginningYearIndex = self.beginningYearIndex
            targetVC.endingYearIndex = self.endingYearIndex
//            targetVC.enableSoundSwitch.isOn = soundEnabled
//            targetVC.slideshowModeSwitch.isOn = slideshowModeEnabled
        }
    }
    
    
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


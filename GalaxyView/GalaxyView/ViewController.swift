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
    var prevDates = [String]()
    var counter = 0
    var beginningYearIndex = Int()
    var endingYearIndex = Int()
    var nightMode = true
    var slideshowMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        beginningYearIndex = 15
        endingYearIndex = possibleYears.count - 1
        newAPOD()
        prevButton.isEnabled = false
    }
    
    //looks through all previous apods in case user wanted to see one. Order is the order in which they were originally viewed
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        counter = counter - 1
        if counter == 0 {
            prevButton.isEnabled = false
        }
        apod.date = prevDates[counter]
        newAPOD()
    }
    
    //changed the button.text to random to make it more user friendly but its still next in my code
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        prevButton.isEnabled = true
        if !prevDates.contains(apod.date){
            prevDates.append(apod.date)
        }
        counter = prevDates.count
        apod.RandomDate(beginningYear: Int(possibleYears[beginningYearIndex])!, endingYear: Int(possibleYears[endingYearIndex])!, excluding: prevDates)
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
            targetVC.nightModeOn = nightMode
            targetVC.slideShowOn = slideshowMode
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


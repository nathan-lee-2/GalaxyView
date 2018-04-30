//
//  ViewController.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var spaceImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var videoLabel: UILabel!
    var apod = APOD()
    var prevDates = [String]()
    var counter = 0
    var beginningYearIndex = Int()
    var endingYearIndex = Int()
    var nightMode = true
    var notificationsOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        beginningYearIndex = 15
        endingYearIndex = possibleYears.count - 1
        //default apod is whatever day it is
        newAPOD()
        prevDates.append(apod.date)
        prevButton.isEnabled = false
        if nightMode {
            view.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
            titleLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.black
        }
    }
    
    //a helper function to save the image to users photo library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    func saveImage(alert: UIAlertAction!) {
        UIImageWriteToSavedPhotosAlbum(spaceImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //should give a popup that allows users to save image to their photo library
    @IBAction func actionButtonPressed(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [spaceImage.image!], applicationActivities: [])
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        present(activityViewController, animated: true, completion: nil)
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
        
        apod.RandomDate(beginningYear: Int(possibleYears[beginningYearIndex])!, endingYear: Int(possibleYears[endingYearIndex])!, excluding: prevDates)
        newAPOD()
        if !prevDates.contains(apod.date){
            prevDates.append(apod.date)
        }
        counter = prevDates.count - 1
    }
    
    func newAPOD() {
        apod.setAPOD {
            self.titleLabel.text = self.apod.title
            if self.apod.mediaType != "image" {
                self.videoLabel.isHidden = false
                self.spaceImage.image = nil
                self.actionButton.isEnabled = false
            }
            else {
                self.videoLabel.isHidden = true
                UIView.animate(withDuration: 2, animations: {self.spaceImage.downloadedFrom(link: self.apod.imageURL)})
                self.actionButton.isEnabled = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MoreInformationPressed" {
            let destination = segue.destination as! InfoViewController
            destination.apod = self.apod
            destination.nightMode = nightMode
        }
        else {
            let destNavigationController = segue.destination as! UINavigationController
            let targetVC = destNavigationController.topViewController as! SettingsViewController
            targetVC.beginningYearIndex = self.beginningYearIndex
            targetVC.endingYearIndex = self.endingYearIndex
            targetVC.nightModeOn = self.nightMode
            targetVC.notificationsOn = self.notificationsOn
        }
    }
    
    
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        if nightMode {
            view.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
            titleLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.black
        }
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


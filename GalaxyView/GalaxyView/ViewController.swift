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
    var yearRestraints = [Int]()
    var apod = APOD()
    var last = APOD() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newAPOD()
        spaceImage.downloadedFrom(link: "https://apod.nasa.gov/apod/image/1801/PerseusCluster_DSSChandra_960.jpg")
        prevButton.isHidden = true
    }
    
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        apod.apodURL = last.apodURL
        prevButton.isHidden = true
        newAPOD()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        prevButton.isHidden = false
        last.apodURL = apod.apodURL
        apod.RandomDate(beginningYear: yearRestraints[0], endingYear: yearRestraints[yearRestraints.count])
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


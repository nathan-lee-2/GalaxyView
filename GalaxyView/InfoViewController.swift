//
//  InfoViewController.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoView: UITextView!
    @IBOutlet weak var poweredByLabel: UILabel!
    var apod = APOD()
    var nightMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if nightMode {
            view.backgroundColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
            titleLabel.textColor = UIColor.white
            dateLabel.textColor = UIColor.white
            infoView.textColor = UIColor.white
            poweredByLabel.textColor = UIColor.white
        } else {
            view.backgroundColor = UIColor.white
            titleLabel.textColor = UIColor.black
            dateLabel.textColor = UIColor.black
            infoView.textColor = UIColor.black
            poweredByLabel.textColor = UIColor.black
        }
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        if apod.mediaType != "image" {
            infoView.text = "Video can be viewed by copy-pasting this link into any browser:\n\n"
            infoView.text.append(apod.imageURL)
            infoView.text.append("\n\n")
            infoView.text.append(apod.explanation)
        } else {
            infoView.text = apod.explanation
        }
        
        infoView.isEditable = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

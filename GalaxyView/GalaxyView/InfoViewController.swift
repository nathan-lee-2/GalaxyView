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
    var apod = APOD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        if apod.imageURL == "" {
            infoView.text = "Video can be viewed at this link: "
            infoView.text.append(apod.mediaType)
            infoView.text.append("\n\n")
            infoView.text.append(apod.explanation)
        } else{
            infoView.text = apod.explanation
        }
        infoView.isEditable = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

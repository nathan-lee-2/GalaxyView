//
//  APOD.swift
//  GalaxyView
//
//  Created by Nathan Lee on 4/28/18.
//  Copyright © 2018 Lee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//APOD stands for Astronomy Picture Of the Day
class APOD {
    
    var date = ""
    var apodURL = ""
    var title = ""
    var explanation = ""
    var imageURL = ""
    var mediaType = ""
    
    // I don't use this but it may come in handy some day
    init(year: Int, month: Int, day: Int) {
        setDate(year: year, month: month, day: day)
    }
    
    init() {}
    
    func setAPOD(completed: @escaping ()->()) {
        setURL()
        Alamofire.request(apodURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let type = json["media_type"].string {
                    self.mediaType = type
                }else {
                    print("Could not return a media type")
                }
                if let pic = json["url"].string {
                    self.imageURL = pic
                    if self.imageURL.hasPrefix("//") {
                        self.imageURL = String(self.imageURL.dropFirst(2))
                    }
                }else {
                    print("Could not return a picture URL")
                }
                if let titleString = json["title"].string {
                    self.title = titleString
                }else {
                    print("Could not return a title")
                }
                if let exp = json["explanation"].string {
                    self.explanation = exp
                }else {
                    print("Could not return an explanation")
                }
                
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
    
    func setURL(){
        if date != ""{
            apodURL = urlBase + apiKey + "&date=" + date
        }
        else {
            apodURL = urlBase + apiKey
        }
    }
    
    // I don't use this in my code but I think it may come in handy some day
    func setDate(year: Int, month: Int, day: Int) {
        date = "\(year)-\(month)-\(day)"
    }
    
    func RandomDate(beginningYear: Int, endingYear: Int, excluding: [String]) {
        let year = Int(arc4random_uniform(UInt32(endingYear-beginningYear))) + beginningYear
        var month = Int()
        if year == 1995 {
            month = Int(arc4random_uniform(UInt32(6))) + 6
        }else if year == 2018 {
            month = Int(arc4random_uniform(UInt32(4))) + 1
        }else {
            month = Int(arc4random_uniform(UInt32(12))) + 1
        }
        var day = Int()
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12{
            day = Int(arc4random_uniform(UInt32(31))) + 1
        } else if month == 4 || month == 6 || month == 9 || month == 11 {
            day = Int(arc4random_uniform(UInt32(30))) + 1
        } else if year%4 == 0{
            day = Int(arc4random_uniform(UInt32(29))) + 1
        } else {
            day = Int(arc4random_uniform(UInt32(28))) + 1
        }
        date = "\(year)-\(month)-\(day)"
        if excluding.contains(date){
            RandomDate(beginningYear: beginningYear, endingYear: endingYear, excluding: excluding)
        }
    }
   
    
}

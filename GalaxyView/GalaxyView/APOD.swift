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

class APOD {
    
    struct Date {
        var year = 0
        var month = 0
        var day = 0
        var dateString = ""
    }
    var apodURL = ""
    var date = Date()
    var title = ""
    var explanation = ""
    var imageURL = ""
    var mediaType = ""
    
    init(year: Int, month: Int, day: Int) {
        setDate(year: year, month: month, day: day)
    }
    init() {
        
    }
    
    func setAPOD(completed: @escaping ()->()) {
        setURL()
        Alamofire.request(apodURL).responseJSON { response in
            print(response)
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
                }else {
                    print("Could not return a picture URL")
                }
                if let exp = json["explanation"].string {
                    self.explanation = exp
                }else {
                    print("Could not return an explanation")
                }
                if let titleString = json["title"].string {
                    self.title = titleString
                }else {
                    print("Could not return a title")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
    
    func setURL(){
        if date.dateString != ""{
            apodURL = urlBase + apiKey + "&date=" + date.dateString
        }
        else {
            apodURL = urlBase + apiKey
        }
        print(apodURL)
    }
    
    func setDate(year: Int, month: Int, day: Int) {
        date.year = year
        date.month = month
        date.day = day
        date.dateString = "\(year)-\(month)-\(day)"
    }
    
    func RandomDate(beginningYear: Int, endingYear: Int) {
        date.year = Int(arc4random_uniform(UInt32(endingYear-beginningYear))) + beginningYear
        date.month = Int(arc4random_uniform(UInt32(12))) + 1
        if date.month == 1 || date.month == 3 || date.month == 5 || date.month == 7 || date.month == 8 || date.month == 10 || date.month == 12{
            date.day = Int(arc4random_uniform(UInt32(31))) + 1
        } else if date.month == 4 || date.month == 6 || date.month == 9 || date.month == 11 {
            date.day = Int(arc4random_uniform(UInt32(30))) + 1
        } else if date.year%4 == 0{
            date.day = Int(arc4random_uniform(UInt32(29))) + 1
        } else {
            date.day = Int(arc4random_uniform(UInt32(28))) + 1
        }
        date.dateString = "\(date.year)-\(date.month)-\(date.day)"
    }
    
   
    
}

//
//  Enums.swift
//  APIAwakens
//
//  Created by EG1 on 10/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation


enum APIError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidUrl
}

enum Category:String{
    case character = "Character"
    case vehicle = "Vehicle"
    case starship = "Starship"
}

enum Message:String{
    case wrongNumber = "Exchange rate can't be zero or negative"
    case emptyField = "Enter an exchange rate"
}

enum Label:String{
    case born = "Born"
    case home = "Home"
    case height = "Height"
    case eyes = "Eyes"
    case hair = "Hair"
    case make = "Make"
    case cost = "Cost"
    case length = "Length"
    case vehicleClass = "Class"
    case crew = "Crew"
}

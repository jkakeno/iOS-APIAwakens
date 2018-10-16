//
//  Vehicle.swift
//  APIAwakens
//
//  Created by EG1 on 10/3/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class Vehicle{
    let name:String
    let model:String
    let manufacturer:String
    let costInCredits:String
    let length:String
    let crew:String
    let vehicleClass:String
    
    init(name:String,model:String,manufacturer:String,costInCredits:String,length:String,crew:String,vehicleClass:String){
        self.name=name
        self.model=model
        self.manufacturer=manufacturer
        self.costInCredits=costInCredits
        self.length=length
        self.crew=crew
        self.vehicleClass=vehicleClass
    }
}

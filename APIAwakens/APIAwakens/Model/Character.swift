//
//  Character.swift
//  APIAwakens
//
//  Created by EG1 on 10/2/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class Character{
    let name:String
    let height:String
    let mass:String
    let hairColor:String
    let eyeColor:String
    let birthYear:String
    let homeWorld:String
    
    init(name: String, height: String, mass: String, hairColor:String, eyeColor:String,birthYear:String,homeWorld:String){
        self.name=name
        self.height=height
        self.mass=mass
        self.hairColor=hairColor
        self.eyeColor=eyeColor
        self.birthYear=birthYear
        self.homeWorld=homeWorld
    }
}

//
//  Character.swift
//  APIAwakens
//
//  Created by EG1 on 10/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

struct Characters:Codable{
    let count:Int
    let next:String
    let results:[CharactersResult]
}

struct CharactersResult:Codable{
    let name:String
    let height:String
    let mass:String
    let hair_color:String
    let eye_color:String
    let birth_year:String
    let homeworld:String
}

struct Planet:Codable{
    let name:String
}

struct Vehicles:Codable{
    let count:Int
    let results:[VehiclesResult]
}

struct VehiclesResult:Codable{
    let name:String
    let model:String
    let manufacturer:String
    let cost_in_credits:String
    let length:String
    let crew:String
    let vehicle_class:String
}

struct Starships:Codable{
    let count:Int
    let results:[StarshipsResult]
}

struct StarshipsResult:Codable{
    let name:String
    let model:String
    let manufacturer:String
    let cost_in_credits:String
    let length:String
    let crew:String
    let starship_class:String
}

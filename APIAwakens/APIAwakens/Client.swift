//
//  Client.swift
//  APIAwakens
//
//  Created by EG1 on 10/1/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import Foundation

class Client{
    

    lazy var baseUrl: URL = {
        return URL(string: "https://swapi.co/api/")!
    }()
    
    let decoder = JSONDecoder()
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    

    typealias CharactersHandler = (Characters?, Error?) -> Void
    typealias PlanetHandler = (Planet?, Error?) -> Void
    typealias VehiclesHandler = (Vehicles?, Error?) -> Void
    typealias StarshipsHandler = (Starships?, Error?) -> Void
    
    func getCharacters(completionHandler completion: @escaping CharactersHandler) {
        
        guard let url = URL(string: "people", relativeTo: baseUrl) else {
            completion(nil, APIError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, APIError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let characters = try self.decoder.decode(Characters.self, from: data)
                            completion(characters, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, APIError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getCharacterHome(_ url:String,completionHandler completion: @escaping PlanetHandler) {

        guard let homeURL = URL(string: url) else {
            completion(nil, APIError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: homeURL)
        
        let task = session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, APIError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let charactersHome = try self.decoder.decode(Planet.self, from: data)
                            completion(charactersHome, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, APIError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getVehicles(completionHandler completion: @escaping VehiclesHandler) {
        
        guard let url = URL(string: "vehicles", relativeTo: baseUrl) else {
            completion(nil, APIError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, APIError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let vehicles = try self.decoder.decode(Vehicles.self, from: data)
                            completion(vehicles, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, APIError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    func getStarships(completionHandler completion: @escaping StarshipsHandler) {
        
        guard let url = URL(string: "starships", relativeTo: baseUrl) else {
            completion(nil, APIError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, APIError.requestFailed)
                        return
                    }
                    if httpResponse.statusCode == 200 {
                        do {
                            let starships = try self.decoder.decode(Starships.self, from: data)
                            completion(starships, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, APIError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}

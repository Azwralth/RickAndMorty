//
//  Character.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 16.03.2024.
//

import Foundation

struct RMCharacter: Decodable {
    let info: Info
    let results: [Character]
}

struct Info: Decodable {
    let pages: Int
    let next: URL?
    let prev: URL?
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let location: LocationInfo
    let image: URL
    
    var description: String {
        """
        Name: \(name)
        
        Status: \(status)
        
        Gender: \(gender)
        
        Location: \(location.name)
        """
    }
}

struct LocationInfo: Decodable {
    let name: String
    let url: String
}

struct RMLocation: Decodable {
    let info: InfoLocation
    let results: [Location]
}

struct Location: Decodable {
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    
    var description: String {
        """
        Name: \(name)
        Type: \(type)
        Dimension: \(dimension)
        """
    }
}

struct InfoLocation: Decodable {
    let pages: Int
    let next: URL?
    let prev: URL?
}

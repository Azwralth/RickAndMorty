//
//  NetworkManager.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 19.03.2024.
//

import Foundation

enum Link {
    case characterUrl
    case locationUrl
    case episodeUrl
    
    var url: URL {
        switch self {
        case .characterUrl:
            URL(string: "https://rickandmortyapi.com/api/character")!
        case .locationUrl:
            URL(string: "https://rickandmortyapi.com/api/location")!
        case .episodeUrl:
            URL(string: "https://rickandmortyapi.com/api/episode")!
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let dataModel = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(dataModel))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

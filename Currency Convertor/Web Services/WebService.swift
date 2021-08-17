//
//  WebService.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation

enum NetworkError: Error {
    case decodingErorr
    case unknownError
}

struct Resource <T> {
    let url: URL
    let parse: (Data) -> T?
}

class Webservice {
    
    
    func load <T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let request = URLRequest.init(url: resource.url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let data = resource.parse(data) {
                    completion(.success(data))
                } else {
                    completion(.failure(.decodingErorr))
                }
                
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
        
    }
}

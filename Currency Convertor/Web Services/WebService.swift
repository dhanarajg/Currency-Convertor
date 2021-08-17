//
//  WebService.swift
//  Currency Convertor
//
//  Created by Dhanaraj on 13/08/21.
//

import Foundation


struct Resource <T> {
    let url: URL
    let parse: (Data) -> T?
}

class Webservice {
    
    func load <T>(resource: Resource<T>, completion: @escaping ((T?) -> ())) {
        
        let request = URLRequest.init(url: resource.url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                completion(resource.parse(data))
            } else {
                completion(nil)
            }
        }.resume()
        
    }
}

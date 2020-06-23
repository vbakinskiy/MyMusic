//
//  NetworkService.swift
//  MyMusic
//
//  Created by Vyacheslav Bakinskiy on 6/22/20.
//  Copyright © 2020 Vyacheslav Bakinskiy. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?)->()) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)", "limit": "10", "media": "music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print("Response error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
            } catch let error {
                print("Data error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

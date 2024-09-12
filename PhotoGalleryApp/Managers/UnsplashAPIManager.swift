//
//  UnsplashAPIManager.swift
//  PhotoGalleryApp
//
//  Created by Арсений Варицкий on 11.09.24.
//

import Foundation
import Alamofire

class UnsplashAPIManager {
    let accessKey = "xyF-qk2cCEm5D52VOycgoSrQn6iNqlqGdLf_E-gQgVM"
    let baseURL = "https://api.unsplash.com/"
    
    func getRandomPhotos(completion: @escaping ([PhotoModel]) -> Void) {
        let url = "\(baseURL)photos/random"
        let parameters: [String: Any] = ["count": 30]
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID \(accessKey)"
        ]
        
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: [PhotoModel].self) { response in
            switch response.result {
            case .success(let photos):
                completion(photos)
            case .failure(let error):
                print("Error fetching random photos: \(error)")
                completion([])
            }
        }
    }
    
    func searchPhotos(query: String, completion: @escaping ([PhotoModel]) -> Void) {
        let url = "\(baseURL)search/photos"
        let parameters: [String: Any] = ["query": query, "per_page": 30]
        
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID \(accessKey)"
        ]
        
        AF.request(url, parameters: parameters, headers: headers).responseDecodable(of: UnsplashSearchResponse.self) { response in
            switch response.result {
            case .success(let searchResponse):
                completion(searchResponse.results)
            case .failure(let error):
                print("Error searching photos: \(error)")
                completion([])
            }
        }
    }
}

struct UnsplashSearchResponse: Codable {
    let results: [PhotoModel]
}

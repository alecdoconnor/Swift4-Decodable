//
//  NetworkRequests.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/15/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

enum RecipeError: Error {
    case networkRequestFailure(Error?)
    case parsingFailure(Error)
}

class NetworkRequests {
    
    static let shared = NetworkRequests()
    
    private let apiURL = "http://api.edamam.com/search"
    private let session = URLSession.shared
    
    private let appID = ""
    private let appKey = ""
    
    private(set) var inProgress: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = (self.inProgress > 0)
            }
        }
    }
    
    private init() {
    }
    
    func searchRecipes(for searchTerm: String, from: Int = 0, to: Int = 30, _ callback: @escaping (([Recipe]?, RecipeError?)->Void)) {
        
        var searchURLComponents = URLComponents(string: apiURL)!

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "app_id", value: appID))
        queryItems.append(URLQueryItem(name: "app_key", value: appKey))
        queryItems.append(URLQueryItem(name: "q", value: searchTerm))
        queryItems.append(URLQueryItem(name: "from", value: "\(from)"))
        queryItems.append(URLQueryItem(name: "to", value: "\(to)"))
        searchURLComponents.queryItems = queryItems

        var request = URLRequest(url: searchURLComponents.url!)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { (data, response, error) in
            self.inProgress -= 1
            guard let data = data else {
                callback(nil, RecipeError.networkRequestFailure(error))
                return
            }
            do {
                let decoder = JSONDecoder()
                let results = try decoder.decode(Results.self, from: data)
                let recipes = results.hits.map{ $0.recipe }
                callback(recipes, nil)
            } catch {
                callback(nil, RecipeError.parsingFailure(error))
            }
        }
        inProgress += 1
        task.resume()
    }
    
}

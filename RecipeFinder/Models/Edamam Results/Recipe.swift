//
//  Recipe.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/15/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import Foundation
import class UIKit.UIImage

struct Recipe: Decodable {
    
    //Parameters provided from API
    var name: String
    var imageURL: URL
    var source: String
    var url: URL
    var sharingURL: URL
    var yield: Int
    var dietLabels: [String]
    var healthLabels: [String]
    var ingredients: [String]
    var calories: Double
    
    //To populate later
    var image: UIImage? = nil
    var hasBegunLoadingImage = false
    
    private enum CodingKeys: String, CodingKey {
        case source, url, yield, dietLabels, healthLabels, calories
        case name = "label"
        case imageURL = "image"
        case sharingURL = "shareAs"
        case ingredients = "ingredientLines"
    }
    
    mutating func setImage(_ image: UIImage?) {
        self.image = image
    }
    
    func loadImage(_ callback: @escaping ((Recipe)->Void)) {
        // The proper way to do this is with NSOperations
        // I will go over this in a future article!
        if image == nil {
            var copy = self
            NetworkRequests.shared.grabImageAt(url: imageURL) { (image) in
                if let image = image {
                    copy.image = image
                    callback(copy)
                }
            }
        }
    }
    
}


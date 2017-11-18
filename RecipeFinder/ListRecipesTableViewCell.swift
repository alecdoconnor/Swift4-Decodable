//
//  ListRecipesTableViewCell.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/16/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class ListRecipesTableViewCell: UITableViewCell {

    var recipe: Recipe? {
        didSet {
            loadRecipeData()
        }
    }
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadRecipeData() {
        recipeImage.image = recipe?.image ?? UIImage(color: UIColor(white: 0.9, alpha: 1.0), size: CGSize(width: 1, height: 1))
        recipeTitle.text = recipe?.name ?? ""
        recipeSource.text = recipe?.source ?? ""
    }

}

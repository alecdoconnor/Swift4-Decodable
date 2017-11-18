//
//  ListRecipesTableViewController.swift
//  RecipeFinder
//
//  Created by Alec O'Connor on 11/15/17.
//  Copyright © 2017 Alec O'Connor. All rights reserved.
//

import UIKit

class ListRecipesTableViewController: UITableViewController {
    
    var recipes = [Recipe]()
    
    var searchController: UISearchController?
    var searchTerm: String! {
        didSet {
            searchForTerm(searchTerm)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController?.searchBar.text = "Apple"
        searchTerm = "Apple"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController?.searchBar
        }
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    func searchForTerm(_ term: String) {
        // In a future tutorial we will replace existing network calls with NSOperations
        NetworkRequests.shared.searchRecipes(for: term) { (recipes, error) in
            if let recipes = recipes, term == self.searchTerm {
                self.recipes = recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listRecipesTableViewController", for: indexPath) as? ListRecipesTableViewCell
        guard let listRecipesCell = cell else {
            return UITableViewCell()
        }
        if recipes[indexPath.row].image == nil && !recipes[indexPath.row].hasBegunLoadingImage {
            recipes[indexPath.row].hasBegunLoadingImage = true
            DispatchQueue.global(qos: .userInteractive).async {
                // In a future tutorial we will replace existing network calls with NSOperations
                let httpURL = URL(string: self.recipes[indexPath.row].imageURL.absoluteString.replacingOccurrences(of: "https://", with: "http://"))!
                let recipeImageData = try! Data(contentsOf: httpURL)
                let recipeImage = UIImage(data: recipeImageData)
                DispatchQueue.main.async {
                    self.recipes[indexPath.row].setImage(recipeImage)
                    let thisCell = self.tableView.cellForRow(at: indexPath) as? ListRecipesTableViewCell
                    thisCell?.recipe = self.recipes[indexPath.row]
                }
            }
        }
        listRecipesCell.recipe = recipes[indexPath.row]
        return listRecipesCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        //Create new view controller to push onto navigation controller
        let recipeTableViewController = storyboard?.instantiateViewController(withIdentifier: "recipeTableViewController") as! RecipeTableViewController
        let recipe = recipes[indexPath.row]
        recipeTableViewController.recipe = recipe
        navigationController?.pushViewController(recipeTableViewController, animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ListRecipesTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchTerm != searchBar.text {
            searchTerm = searchBar.text ?? ""
        }
    }
}

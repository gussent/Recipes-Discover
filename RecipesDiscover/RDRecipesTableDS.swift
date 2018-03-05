//
//  RDRecipesTableDS.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDRecipesTableDS: NSObject, UITableViewDataSource, UISearchBarDelegate
{
    weak var recipesTableView: RDRecipesTableView!
    weak var controller: RDRecipesListVC!
    
    var recipesFetcher: RDRecipesFetching!
    var searchText: String = ""
    
    // MARK: - Public methods
    
    func reloadData()
    {
        recipesFetcher.performFetch(searchString: searchText, sorting: controller.getCurrentSorting())
        {
            recipesTableView.reloadData()
            
            if recipesFetcher.count > 0 { DispatchQueue.main.async
            {
                self.recipesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }}
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recipesFetcher.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return tableView.dequeueReusableCell(withIdentifier: RDRecipesListCell.rid, for: indexPath)
    }
    
    // MARK: - RDRecipesTableDS
    
    func tableView(_ tableView: UITableView, recipeForRowAt indexPath: IndexPath) -> RDRecipe?
    {
        return recipesFetcher.recipe(atIndex: indexPath.row)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        recipesTableView.setContentOffset(CGPoint(x: 0, y: -8), animated: true)
        self.searchText = searchText
        reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchText = ""
        reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        reloadData()
    }
    
    // MARK: - Sorting handlers
    
    func setSort(by sorting: RecipesSorting)
    {
        reloadData()
    }
    
    // MARK: - Initialization
    
    init(tableView: RDRecipesTableView, controller: RDRecipesListVC)
    {
        super.init()
    
        self.recipesTableView = tableView
        self.controller = controller
        
        tableView.dataSource = self
        recipesFetcher = RDRealmRecipesFetcher()
    }

}

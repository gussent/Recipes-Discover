//
//  RDRecipesTableDS.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDRecipesTableDS: NSObject, UITableViewDataSource
{
    weak var recipesTableView: RDRecipesTableView!
    weak var controller: RDRecipesListVC!
    
    var recipesFetcher: RDRecipesFetching!
    
    private var searchText: String = ""
    private var sorting: RecipesSorting = .name(true)
    
    // MARK: - Public methods
    
    func setSearchText(_ searchText: String)
    {
        self.searchText = searchText
        reloadData()
    }
    
    func setSort(by sorting: RecipesSorting)
    {
        self.sorting = sorting
        reloadData()
    }
    
    func reloadData()
    {
        recipesFetcher.performFetch(searchString: searchText, sorting: sorting)
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

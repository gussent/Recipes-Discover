//
//  RDRecipesTablePR.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

// Recipies tableView presenter (delegate)

class RDRecipesTablePR: NSObject, UITableViewDelegate
{
    weak private var tableView: RDRecipesTableView!
    weak private var datasource: RDRecipesTableDS!
    weak private var controller: RDRecipesListVC!

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard
            let customCell = cell as? RDRecipesListCell,
            let recipe = datasource.tableView(tableView, recipeForRowAt: indexPath)
        else
            {return}
        
        customCell.configureWith(recipe)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        guard let customCell = cell as? RDRecipesListCell else {return}
        
        customCell.invalidate()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        controller.showRecipeDetails()
    }
    
    // MARK: - Setup
    
    func registerCell()
    {
        tableView.register(RDRecipesListCell.nib, forCellReuseIdentifier: RDRecipesListCell.rid)
    }
    
    // MARK: - Initialization
    
    init(tableView: RDRecipesTableView, datasource: RDRecipesTableDS, controller: RDRecipesListVC)
    {
        super.init()
    
        self.tableView = tableView
        self.datasource = datasource
        self.controller = controller
        
        tableView.delegate = self
        
        registerCell()
    }

}

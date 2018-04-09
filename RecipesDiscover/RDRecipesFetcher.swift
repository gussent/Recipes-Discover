//
//  File.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import Foundation
import RealmSwift

// For future hypohetical cases
protocol RDRecipesFetching: class
{
    var count: Int {get}
    func recipe(atIndex: Int) -> RDRecipe?
    func performFetch(completionHandler: ()->())
    func performFetch(searchString: String, sorting: RecipesSorting, completionHandler: ()->())
}

class RDRealmRecipesFetcher: RDRecipesFetching
{
    var recipes: Results<RDRecipe>?
    
    func performFetch(completionHandler: ()->())
    {
        performFetch(searchString: "", sorting: .name(true), completionHandler: completionHandler)
    }
    
    func performFetch(searchString: String, sorting: RecipesSorting, completionHandler: ()->())
    {
        guard let realm = try? Realm() else {return}
        
        recipes = realm.objects(RDRecipe.self)
        
        if searchString.count > 0
        {
            recipes = recipes?.filter("name contains[cd] %@ OR recipeDescription contains[cd] %@ OR instructions contains[cd] %@", searchString, searchString, searchString)
        }
        
        switch sorting
        {
            case .name(let asc): recipes = recipes?.sorted(byKeyPath: "name", ascending: asc)
            case .date(let asc): recipes = recipes?.sorted(byKeyPath: "lastUpdated", ascending: asc)
        }
        
        completionHandler()
    }
    
    var count: Int { return recipes?.count ?? 0 }
    
    func recipe(atIndex index: Int) -> RDRecipe?
    {
        return recipes?[index]
    }
}

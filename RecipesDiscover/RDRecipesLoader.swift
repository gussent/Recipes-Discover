//
//  RDRecipesLoader.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import Foundation
import RealmSwift

class RDRecipesLoader
{
    class func loadRecipes(_ completionHandler: @escaping ()->())
    {
        guard let url = URL(string: "http://cdn.sibedge.com/temp/recipes.json") else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler:
        { (data, response, error) -> Void in
            
            if let jsonRaw = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments),
               let json = jsonRaw as? Dictionary<String, Any>,
               let recipes = json["recipes"] as? [Dictionary<String, Any>],
               let realm = try? Realm()
            {
                realm.beginWrite()
                
                realm.deleteAll()
                
                for recipeDictionary in recipes
                {
                    save(recipeDictionary: recipeDictionary, toRealm: realm)
                }
                
                do { try realm.commitWrite() }
                catch {}
                
                completionHandler()
            }
        }).resume()
    }
    
    class func save(recipeDictionary: Dictionary<String, Any>, toRealm realm: Realm)
    {
        guard
            let uuid = recipeDictionary["uuid"] as? String,
            let name = recipeDictionary["name"] as? String
        else
            {return}
        
        let recipe = RDRecipe()
        
        // Required fields
        recipe.uuid = uuid
        recipe.name = name
        
        // Optional fields
        recipe.recipeDescription = (recipeDictionary["description"] as? String) ?? ""
        recipe.instructions = (recipeDictionary["instructions"] as? String) ?? ""
        recipe.difficulty = (recipeDictionary["difficulty"] as? Int) ?? 1
        
        if let timeInterval = recipeDictionary["lastUpdated"] as? TimeInterval
        {
            recipe.lastUpdated = Date(timeIntervalSince1970: timeInterval)
        }
        
        if let images = recipeDictionary["images"] as? [String]
        {
            for imageUrl in images
            {
                recipe.images.append(RDRecipeImage(url: imageUrl, recipe: recipe))
            }
        }
        
        realm.add(recipe)
    }
    
}
































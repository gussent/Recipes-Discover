//
//  RDRecipe.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import Foundation
import RealmSwift

class RDRecipe: Object
{
    @objc dynamic var uuid: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var lastUpdated: Date?
    @objc dynamic var recipeDescription: String = ""
    @objc dynamic var instructions: String = ""
    @objc dynamic var difficulty: Int = 0
    
    let images = List<RDRecipeImage>()
    
    override static func indexedProperties() -> [String]
    {
        return ["lastUpdated", "name", "recipeDescription", "instructions"]
    }
}

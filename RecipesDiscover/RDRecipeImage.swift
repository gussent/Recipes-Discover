//
//  RDRecipeImage.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit
import RealmSwift

class RDRecipeImage: Object
{
    @objc dynamic var url: String = ""
    @objc dynamic var recipe: RDRecipe?
    
    convenience init(url: String, recipe: RDRecipe)
    {
        self.init()
        
        self.url = url
        self.recipe = recipe
    }
}

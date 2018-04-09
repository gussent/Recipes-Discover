//
//  RDRootVC.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDRootVC: UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        view.backgroundColor = .rdNavigationBackground
        
        navigationBar.barTintColor = .rdNavigationBackground
        
        navigationBar.titleTextAttributes =
        [
            NSAttributedStringKey.font: UIFont.rdMedium(24),
            NSAttributedStringKey.foregroundColor: UIColor.rdNavigationForeground
        ]
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
}

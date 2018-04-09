//
//  RDRecipesListVC.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

enum RecipesSorting
{
    case name (Bool)
    case date (Bool)
}

class RDRecipesListVC: UIViewController, UISearchBarDelegate
{
    // MARK: - Outlets
    
    @IBOutlet private weak var tableView: RDRecipesTableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var sortingControl: RDSegmentedControl!
    @IBOutlet weak var sortingContainer: UIView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var tableHeaderControls: UIView!
    
    // MARK: - Instance vars
    
    private var presenter: RDRecipesTablePR!
    private var datasource: RDRecipesTableDS!
    
    private var sorting: RecipesSorting! {didSet {onSortingChanged()}}
    private var searchText: String = ""
    
    // MARK: - Public Api
    
    func getCurrentSorting() -> RecipesSorting
    {
        return sorting
    }
    
    // MARK: - Lifetime
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        sorting = .name(true)
        
        datasource = RDRecipesTableDS(tableView: tableView, controller: self)
        presenter = RDRecipesTablePR(tableView: tableView, datasource: datasource, controller: self)
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        title = "Recipes Discover"
    
        setupApprearance()

        RDRecipesLoader.loadRecipes
        { [weak self] in
        
            DispatchQueue.main.async
            {
                self?.datasource.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Setup

    private func setupApprearance()
    {
        view.backgroundColor = .rdMainBackgroundDarker
        searchBar.barTintColor = .rdMainBackground
        searchBar.barStyle = .default
        sortingContainer.backgroundColor = .rdMainBackground
        sortingLabel.textColor = .rdSortingControls
        sortingControl.tintColor = .rdSortingControls
        
        searchBar.barStyle = .blackTranslucent
        
        tableHeaderControls.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableHeaderControls.layer.shadowOpacity = 0.8
        tableHeaderControls.layer.shadowColor = UIColor.black.cgColor
        tableHeaderControls.layer.shadowRadius = 8
        
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        tableView.alwaysBounceHorizontal = false
        tableView.alwaysBounceVertical = false
        
        sortingLabel.font = .rdMedium(16)
        
        sortingControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.rdMedium(16)], for: .normal)
    }

    // MARK: - Actions

    @IBAction func onSortingChanged(_ sender: UISegmentedControl)
    {
        switch sorting!
        {
            case .name (let asc): sorting = sender.selectedSegmentIndex == 0 ? .name(!asc) : .date(true)
            case .date (let asc): sorting = sender.selectedSegmentIndex == 1 ? .date(!asc) : .name(true)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        tableView.setContentOffset(CGPoint(x: 0, y: -8), animated: true)
        self.searchText = searchText
        datasource.setSearchText(searchText)
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
        datasource.setSearchText(searchText)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        datasource.reloadData()
    }
    
    // MARK: - Private methods

    func showRecipeDetails()
    {
        guard
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let recipe = datasource.tableView(tableView, recipeForRowAt: selectedIndexPath)
        else
            {return}
        
        let recipeDetailsVC = RDRecipeDetailsVC()
        recipeDetailsVC.recipe = recipe
        navigationController?.pushViewController(recipeDetailsVC, animated: true)
    }

    private func onSortingChanged()
    {
        guard datasource != nil, sorting != nil else {return}
        datasource.setSort(by: sorting)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
    
        let location = tableHeaderControls.convert(touches.first!.location(in: view), from: view)
        if tableHeaderControls.frame.contains(location)
        {
            searchBar.resignFirstResponder()
        }
    }

    deinit
    {
        print("DEINIT: \(self)")
    }
}

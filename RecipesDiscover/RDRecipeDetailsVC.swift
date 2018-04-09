//
//  RDRecipeDetailsVC.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDRecipeDetailsVC: UIViewController
{
    var recipe: RDRecipe?
    var imagesPaginationVC: RDImagesPaginationVC!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imagesContainer: UIView!
    
    @IBOutlet weak var difficultyContainer: UIView!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    @IBOutlet weak var descriptionContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var instructionsContainer: UIView!
    @IBOutlet weak var instructionsTitleLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    // Constraints
    
    @IBOutlet weak var cnstrNameLabelTop: NSLayoutConstraint!
    @IBOutlet weak var cnstrNameLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var cnstrNameLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var cnstrNameLabelRight: NSLayoutConstraint!
    @IBOutlet weak var cnstrInstructionsContainerTop: NSLayoutConstraint!
    @IBOutlet weak var cnstrDescriptionContainerTop: NSLayoutConstraint!
    
    // MARK: - Lifetime
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.rdNavigationForeground
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.rdMainBackgroundDarker
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0)
        scrollView.bounces = false
        
        setupName()
        setupImages()
        setupDifficulty()
        setupDescription()
        setupInstructions()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Setup

    private func setupName()
    {
        guard let recipe = recipe else {return}
        
        nameContainer.backgroundColor = UIColor.rdCellBackground
        
        nameLabel.text = recipe.name
        nameLabel.font = .rdMedium(22)
        nameLabel.textColor = UIColor.rdRecipeName
        
        cnstrNameLabelTop.constant = 16
        cnstrNameLabelBottom.constant = 16
        cnstrNameLabelLeft.constant = 16
        cnstrNameLabelRight.constant = 16
    }

    private func setupImages()
    {
        guard let recipe = recipe else {return}
        
        imagesContainer.backgroundColor = .clear
        
        imagesPaginationVC = RDImagesPaginationVC()
        
        imagesPaginationVC.imageUrlStrings = recipe.images.map {return $0.url}
        
        let ipView = imagesPaginationVC.view!
        
        addChildViewController(imagesPaginationVC)
        
        imagesContainer.addSubview(ipView)
        ipView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
        [
            ipView.topAnchor.constraint(equalTo: imagesContainer.topAnchor),
            ipView.leftAnchor.constraint(equalTo: imagesContainer.leftAnchor),
            ipView.rightAnchor.constraint(equalTo: imagesContainer.rightAnchor),
            ipView.bottomAnchor.constraint(equalTo: imagesContainer.bottomAnchor),
        ])
        
        imagesPaginationVC.didMove(toParentViewController: self)
        
        view.layoutIfNeeded()
    }

    private func setupDifficulty()
    {
        guard let recipe = recipe else {return}
        
        difficultyContainer.backgroundColor = .clear
        
        let title = "Difficulty level: "
        let value: String =
        {
            switch recipe.difficulty
            {
                case 1: return "newbie"
                case 2: return "mommy"
                case 3: return "rookie"
                case 4: return "chief"
                case 5: return "grand meister"
                default: return "unknown"
            }
        }()
        
        let attrTitle = NSMutableAttributedString(string: title, attributes:
        [
            NSAttributedStringKey.font: UIFont.rdMedium(16),
            NSAttributedStringKey.foregroundColor: UIColor.rdRecipeDescription
        ])
        
        let attrValue = NSAttributedString(string: value, attributes:
        [
            NSAttributedStringKey.font: UIFont.rdBold(16),
            NSAttributedStringKey.foregroundColor: UIColor.rdRecipeName
        ])
        
        attrTitle.append(attrValue)
        
        difficultyLabel.attributedText = attrTitle
    }

    private func setupDescription()
    {
        guard let recipe = recipe else {return}
        
        cnstrDescriptionContainerTop.constant = (recipe.recipeDescription.count == 0) ? 0 : 16
        
        descriptionContainer.backgroundColor = .clear
        
        descriptionLabel.text = recipe.recipeDescription
        
        descriptionLabel.textColor = UIColor.rdRecipeDescription
        descriptionLabel.font = UIFont.rdMedium(14)
    }

    private func setupInstructions()
    {
        guard let recipe = recipe else {return}
        
        cnstrInstructionsContainerTop.constant = 16
        
        instructionsContainer.backgroundColor = .clear
        
        instructionsTitleLabel.text = "Instructions"
        instructionsTitleLabel.textColor = UIColor.rdRecipeName
        instructionsTitleLabel.font = UIFont.rdMedium(16)
        
        instructionsLabel.attributedText = recipe.instructions.convertHtml(withAttributes:
        [
            NSAttributedStringKey.font: UIFont.rdMedium(14),
            NSAttributedStringKey.foregroundColor: UIColor.rdRecipeDescription
        ])
    }

    deinit
    {
        print("DEINIT: \(self)")
    }

}

extension String
{
    func convertHtml(withAttributes attributes: [NSAttributedStringKey: Any]?) -> NSAttributedString
    {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] =
        [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        if let string = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
        {
            string.setAttributes(attributes, range: NSMakeRange(0, string.length))
            return string
        }
        else
        {
            return NSAttributedString()
        }
    }
}

//
//  RDRecipesListCell.swift
//  RecipesDiscover
//
//  Created by Dmitry Kovalev on 03/03/2018.
//  Copyright © 2018 Dmitry Kovalev. All rights reserved.
//

import UIKit

class RDRecipesListCell: UITableViewCell
{
    // MARK: - Outlets
    
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var recipeImageView: RDAsyncImageView!
    
    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    // Constraints
    
    @IBOutlet weak var cnstrImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var cnstrImageViewLeft: NSLayoutConstraint!
    @IBOutlet weak var cnstrImageViewBottom: NSLayoutConstraint!
    @IBOutlet weak var cnstrImageViewRight: NSLayoutConstraint!
    @IBOutlet weak var cnstrDetailsContainerRight: NSLayoutConstraint!
    
    @IBOutlet weak var cnstrRootViewLeft: NSLayoutConstraint!
    @IBOutlet weak var cnstrRootViewRight: NSLayoutConstraint!
    @IBOutlet weak var cnstrRootViewBottom: NSLayoutConstraint!

    @IBOutlet weak var cnstrLastUpdateLabelBottom: NSLayoutConstraint!
    
    // MARK: - Reuse ID and NIB
    
    class var rid: String {return String(describing: self)}
    class var nib: UINib  {return UINib(nibName: rid, bundle: nil)}
    
    var dateFormatter: DateFormatter!
    
    // MARK: - Initialization
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        selectionStyle = .none
        
        setupDateFormatter()
        setupAppearance()
    }
    
    // MARK: - Reconfiguration
    
    func configureWith(_ descriptor: RDRecipe)
    {
        let recipe = descriptor
        
        nameLabel.text = recipe.name
        descriptionLabel.text = recipe.recipeDescription
        
        if let date = recipe.lastUpdated {lastUpdatedLabel.text = dateFormatter.string(from: date)}
        else                             {lastUpdatedLabel.text = ""}
        
        if let imageUrlString = recipe.images.first?.url
        {
            recipeImageView.downloadImage(imageUrlString)
        }
        
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
    func invalidate()
    {
        recipeImageView.cancelDownload()
    }
    
    // MARK: - Setup
    
    private func setupDateFormatter()
    {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("YYYYMMMMd")
    }
    
    private func setupAppearance()
    {
        nameLabel.numberOfLines = 1
        descriptionLabel.numberOfLines = 2
    
        rootView.backgroundColor = .rdCellBackground
        nameLabel.textColor = .rdRecipeName
        descriptionLabel.textColor = .rdRecipeDescription
        lastUpdatedLabel.textColor = .rdRecipeDate
        
        rootView.layer.cornerRadius = 5
        rootView.layer.masksToBounds = true
        
        recipeImageView.layer.cornerRadius = 5
        recipeImageView.layer.masksToBounds = true
        
        cnstrImageViewTop.constant = 8
        cnstrImageViewLeft.constant = 8
        cnstrImageViewBottom.constant = 8
        cnstrDetailsContainerRight.constant = 8
        
        cnstrRootViewLeft.constant = 8
        cnstrRootViewRight.constant = 8
        cnstrRootViewBottom.constant = 8
        
        cnstrLastUpdateLabelBottom.constant = 0
        
        nameLabel.font = .rdMedium(14)
        descriptionLabel.font = .rdMedium(12)
        lastUpdatedLabel.font = .rdMedium(10)
        
    }
    
    // MARK: - Handlers
    
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool)
    {
        
    }
}

//
//  ImageQuoteCell.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-05.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class PortfolioItemCell: UITableViewCell {
    
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var portfolioItemView: UIImageView!
    @IBOutlet weak var portfolioItemViewOverlay: UIView!
    @IBOutlet weak var portfolioItemQuote: UILabel!
    
    var currentPortfolioItem: PortfolioItem!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        portfolioItemViewOverlay.isHidden = true
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    func configureCell(portfolioItem: PortfolioItem){
        
        currentPortfolioItem = portfolioItem
        
        if let portfolioItemImage = portfolioItem.image?.img as Data? {
            portfolioItemView.image = UIImage(data: portfolioItemImage)
        } else {
            portfolioItemView.image = UIImage(named: "original")
        }
        
        portfolioItemQuote.text = portfolioItem.quote
        
    }

}

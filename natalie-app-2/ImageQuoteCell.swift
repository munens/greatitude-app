//
//  ImageQuoteCell.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-05.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import UIKit

class ImageQuoteCell: UITableViewCell {
    
    @IBOutlet weak var viewBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var quoteImageView: UIImageView!
    @IBOutlet weak var quoteImageOverlay: UIView!
    @IBOutlet weak var imageQuoteName: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quoteImageOverlay.isHidden = true
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */
    
    func configureCell(){
        // give the quote image view an image to place on UI:
        quoteImageView.image = UIImage(named: "original")
    }

}

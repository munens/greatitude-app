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
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quoteImageView.isHidden = true
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    */

}

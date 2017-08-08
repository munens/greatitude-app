//
//  BackgroundImageCell.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-18.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import UIKit

class BackgroundImageCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageLabel: UILabel!
    
    var background: BackgroundImage!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureCell(_ background: BackgroundImage){
        self.background = background
        // using s3:
        // backgroundImageView.image = UIImage(named: "\(self.background.imageURL)" )
        
        backgroundImageView.image = UIImage(named: "\(self.background.filename)" )
        //backgroundImageLabel.text = self.backgroundImage.name
    }
    
}

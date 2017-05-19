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
    
    var backgroundImage: BackgroundImage!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureCell(_ backgroundImage: BackgroundImage){
        self.backgroundImage = backgroundImage
        
        backgroundImageView.image = UIImage(named: "\(self.backgroundImage.name)" )
        //backgroundImageLabel.text = self.backgroundImage.name
    }
    
}

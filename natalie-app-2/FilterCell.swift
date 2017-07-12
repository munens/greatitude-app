//
//  FilterCell.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-07-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import UIKit

class FilterCell: UICollectionViewCell {
    
    @IBOutlet weak var filterImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(filterImage: UIImage){
        self.filterImageView.image = filterImage
    }
}

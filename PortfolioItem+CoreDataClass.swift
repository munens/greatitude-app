//
//  PortfolioItem+CoreDataClass.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import CoreData

@objc(PortfolioItem)
public class PortfolioItem: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // create a date whenever new portfolio item is created:
        self.created_at = NSDate()
    }
}

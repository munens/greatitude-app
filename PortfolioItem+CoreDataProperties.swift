//
//  PortfolioItem+CoreDataProperties.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import CoreData


extension PortfolioItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioItem> {
        return NSFetchRequest<PortfolioItem>(entityName: "PortfolioItem")
    }

    @NSManaged public var quote: String?
    @NSManaged public var created_at: NSDate?
    @NSManaged public var user: User?
    @NSManaged public var image: Image?
    @NSManaged public var portfolio: Portfolio?

}

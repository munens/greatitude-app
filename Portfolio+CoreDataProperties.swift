//
//  Portfolio+CoreDataProperties.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import CoreData


extension Portfolio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Portfolio> {
        return NSFetchRequest<Portfolio>(entityName: "Portfolio")
    }

    @NSManaged public var name: String?
    @NSManaged public var portfolioItem: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for portfolioItem
extension Portfolio {

    @objc(addPortfolioItemObject:)
    @NSManaged public func addToPortfolioItem(_ value: PortfolioItem)

    @objc(removePortfolioItemObject:)
    @NSManaged public func removeFromPortfolioItem(_ value: PortfolioItem)

    @objc(addPortfolioItem:)
    @NSManaged public func addToPortfolioItem(_ values: NSSet)

    @objc(removePortfolioItem:)
    @NSManaged public func removeFromPortfolioItem(_ values: NSSet)

}

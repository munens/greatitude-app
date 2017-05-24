//
//  User+CoreDataProperties.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-24.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var created_at: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var password: String?
    @NSManaged public var portfolio: NSSet?
    @NSManaged public var portfolioItem: NSSet?

}

// MARK: Generated accessors for portfolio
extension User {

    @objc(addPortfolioObject:)
    @NSManaged public func addToPortfolio(_ value: Portfolio)

    @objc(removePortfolioObject:)
    @NSManaged public func removeFromPortfolio(_ value: Portfolio)

    @objc(addPortfolio:)
    @NSManaged public func addToPortfolio(_ values: NSSet)

    @objc(removePortfolio:)
    @NSManaged public func removeFromPortfolio(_ values: NSSet)

}

// MARK: Generated accessors for portfolioItem
extension User {

    @objc(addPortfolioItemObject:)
    @NSManaged public func addToPortfolioItem(_ value: PortfolioItem)

    @objc(removePortfolioItemObject:)
    @NSManaged public func removeFromPortfolioItem(_ value: PortfolioItem)

    @objc(addPortfolioItem:)
    @NSManaged public func addToPortfolioItem(_ values: NSSet)

    @objc(removePortfolioItem:)
    @NSManaged public func removeFromPortfolioItem(_ values: NSSet)

}

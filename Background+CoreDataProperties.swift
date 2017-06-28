//
//  Background+CoreDataProperties.swift
//  
//
//  Created by Munene Kaumbutho on 2017-06-28.
//
//

import Foundation
import CoreData


extension Background {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Background> {
        return NSFetchRequest<Background>(entityName: "Background")
    }

    @NSManaged public var filename: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?

}

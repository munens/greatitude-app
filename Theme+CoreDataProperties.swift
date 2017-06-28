//
//  Theme+CoreDataProperties.swift
//  
//
//  Created by Munene Kaumbutho on 2017-06-28.
//
//

import Foundation
import CoreData


extension Theme {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Theme> {
        return NSFetchRequest<Theme>(entityName: "Theme")
    }

    @NSManaged public var filename: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?

}

//
//  Image+CoreDataClass.swift
//  natalie-app-2
//
//  Created by Kuzivakwashe Mutonga on 2017-04-12.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation
import CoreData


public class Image: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created_at = NSDate()
    }
}

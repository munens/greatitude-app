//
//  backgroundImage.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-05-18.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation

class BackgroundImage {
    
    private var _name: String!
    
    var name: String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    init(name: String){
        self._name = name
    }
    
}

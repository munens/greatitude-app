//
//  Theme.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-06-28.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation

//
//  theme.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-06-27.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation

class ThemeImage {
    
    
    private var _filename: String!
    
    private var _name: String!
    
    private var _imageURL: String!
    
    
    var filename: String {
        
        if _filename == nil {
            
            return ""
            
        }
        
        return _filename
        
    }
    
    
    var name: String {
        
        if _name == nil {
            
            return ""
            
        }
        
        return _name
        
    }
    
    
    var imageURL: String {
        
        get {
            
            return _imageURL
            
        } set {
            
            _imageURL = newValue
        }
    }
    
    
    init(filename: String, name: String, imageURL: String) {
        
        self._filename = filename
        
        self._name = name
        
        self._imageURL = imageURL
    }
}

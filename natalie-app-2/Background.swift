//
//  File.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-06-28.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation

class Background {
    
    private var _name: String!
    
    private var _filename: String!
    
    private var _imageURL: String!
    
    
    var name: String {
        
        if _name == nil {
            
            return ""
            
        }
        
        return _name
        
    }
    
    
    var filename: String {
        
        if _filename == nil {
            
            return ""
            
        }
        
        return _filename
        
    }
    
    
    var imageURL: String {
        
        get {
            
            return _imageURL
            
        } set {
            
            _imageURL = newValue
        }
    }
    
    
    init(name: String, filename: String, imageURL: String){
        
        self._name = name
        
        self._filename = filename
        
        self._imageURL = imageURL
    }
    
}

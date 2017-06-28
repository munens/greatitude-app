//
//  theme.swift
//  natalie-app-2
//
//  Created by Munene Kaumbutho on 2017-06-27.
//  Copyright © 2017 Munene Kaumbutho - Evan Zhang. All rights reserved.
//

import Foundation


class Theme {
    
    private var _filename: String!
    private var _name: String!
    private var _url: String!
    
    var filename:String {
        if _filename == nil {
            return ""
        }
        return _filename
    }
    
    var name:String {
        if _name == nil {
            return ""
        }
        return _name
    }
    
    var url:String {
        get {
            return _url
        } set {
            _url = newValue
        }
    }
    
    init(filename: String, name: String, url: String) {
        self._filename = filename
        self._name = name
        self._url = url
    }
}

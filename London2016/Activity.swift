//
//  Activity.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import Foundation

class Activity {
    private var _name: String!
    private var _image: String!
    private var _description: String!
    private var _date: NSDate?
    private var _price: String?
    
    var name: String {
        return _name
    }
    
    var image: String {
        return _image
    }
    
    var description: String {
        return _description
    }
    
    var date: NSDate? {
        return _date
    }
    
    var price: String? {
        return _price
    }
    
    init(name: String, image: String, description: String) {
        self._name = name
        self._image = image
        self._description = description
    }
    
}
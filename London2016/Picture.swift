//
//  Picture.swift
//  London2016
//
//  Created by Lesley on 02-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import Foundation
import Firebase

class Picture {
    private var _pictureName: String!
    private var _pictureDescription: String!
    private var _pictureImage: String!
    private var _pictureKey: String!
    private var _pictureRef: Firebase!
    
    var pictureName: String {
        return _pictureName
    }
    
    var pictureDescription: String {
        return _pictureDescription
    }
    
    var pictureImage: String {
        return _pictureImage
    }
    
    var pictureKey: String {
        return _pictureKey
    }
    
    var pictureRef: Firebase {
        return _pictureRef
    }
    
    init(title: String, description: String, imageUrl: String) {
        self._pictureName = title
        self._pictureDescription = description
        self._pictureImage = imageUrl
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._pictureKey = postKey
        
        if let title = dictionary["name"] as? String {
            self._pictureName = title
        }
        
        if let description = dictionary["description"] as? String {
            self._pictureDescription = description
        }
        
        if let imageUrl = dictionary["imageUrl"] as? String {
            self._pictureImage = imageUrl
        }
        
        self._pictureRef = DataService.ds.REF_PICTURES.childByAppendingPath(self._pictureKey)
        
    }
}

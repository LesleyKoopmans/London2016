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
    private var _pictureDict = Dictionary<String, AnyObject>()
    private var _pictureLocation: String?
    private var _pictureLatitude: Double?
    private var _pictureLongitude: Double?
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
    
    var pictureDict: Dictionary<String, AnyObject>? {
        return _pictureDict
    }
    
    var pictureLocation: String? {
        return _pictureLocation
    }
    
    var pictureLatitude: Double? {
        return _pictureLatitude
    }
    
    var pictureLongitude: Double? {
        return _pictureLongitude
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
        
        if let imageDict = dictionary["images"] as? Dictionary<String, AnyObject> {
            if let imageUrl = imageDict["image1"] as? String {
                self._pictureImage = imageUrl
            }
            
            for item in imageDict {
                self._pictureDict.updateValue(item.0, forKey: item.1 as! String)
            }
            
        }
        
        if let location = dictionary["location"] as? String {
            self._pictureLocation = location
        }
        
        if let latitude = dictionary["latitude"] as? Double {
            self._pictureLatitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? Double {
            self._pictureLongitude = longitude
        }
        
        self._pictureRef = DataService.ds.REF_PICTURES.childByAppendingPath(self._pictureKey)
    
    }
}

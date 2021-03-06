//
//  Activity.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import Foundation
import Firebase

class Activity {
    private var _activityName: String!
    private var _activityImage: String?
    private var _activityDescription: String!
    private var _activityDate: String?
    private var _activityPrice: String?
    private var _activityUrl: String?
    private var _activityKey: String!
    private var _eventId: String?
    private var _activityRef: Firebase!
    
    var activityName: String {
        return _activityName
    }
    
    var activityImage: String? {
        return _activityImage
    }
    
    var activityDescription: String {
        return _activityDescription
    }
    
    var activityDate: String? {
        return _activityDate
    }
    
    var activityPrice: String? {
        return _activityPrice
    }
    
    var activityUrl: String? {
        return _activityUrl
    }
    
    var activityKey: String! {
        return _activityKey
    }
    
    var eventId: String? {
        return _eventId
    }
    
    init(name: String, image: String, description: String) {
        self._activityName = name
        self._activityImage = image
        self._activityDescription = description
    }
    
    init(activityKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._activityKey = activityKey
        
        if let date = dictionary["date"] as? String {
            self._activityDate = date
        }
        
        if let price = dictionary["price"] as? String {
            self._activityPrice = price
        }
        
        if let url = dictionary["url"] as? String {
            self._activityUrl = url
        }
        
        if let name = dictionary["name"] as? String {
            self._activityName = name
        }
        
        if let desc = dictionary["description"] as? String {
            self._activityDescription = desc
        }
        
        if let image = dictionary["imageUrl"] as? String {
            self._activityImage = image
        }
        
        if let eventId = dictionary["eventId"] as? String {
            self._eventId = eventId
        }
        
        self._activityRef = DataService.ds.REF_ACTIVITY.childByAppendingPath(self._activityKey)
        
    }
    
}
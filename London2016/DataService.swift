//
//  DataService.swift
//  London2016
//
//  Created by Lesley on 16-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://london2016.firebaseio.com"

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = Firebase(url: "\(URL_BASE)")
    private var _REF_ACTIVITY = Firebase(url: "\(URL_BASE)/activity")
    private var _REF_PICUTURES = Firebase(url: "\(URL_BASE)/pictures")
    
    var REF_BASE: Firebase {
        return _REF_BASE
    }
    
    var REF_ACTIVITY: Firebase {
        return _REF_ACTIVITY
    }
    
    var REF_PICTURES: Firebase {
        return _REF_PICUTURES
    }
    
}

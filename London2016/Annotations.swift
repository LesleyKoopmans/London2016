//
//  Annotations.swift
//  London2016
//
//  Created by Lesley on 13-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import Foundation
import MapKit

class Annotations: NSObject, MKAnnotation {
    
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
//
//  ContentViewController.swift
//  London2016
//
//  Created by Lesley on 08-06-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ContentViewController: UIViewController, MKMapViewDelegate {
    
    //OUTLETS
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var viewFromLabel: UIView!
    
    //VARIABLES AND LETS
    var pageIndex: Int!
    var titleText: String!
    var imageFile: UIImage!
    
    
    var post: Picture!
    var request: Request?
    var coordinate: CLLocationCoordinate2D?
    var pictures = [String:UIImage]()
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postImage.image = imageFile
        self.postImage.clipsToBounds = true
        self.descriptionLbl.text = self.titleText
        
        viewFromLabel.backgroundColor = UIColor.init(red: 0, green: 145 / 255.0, blue: 138 / 255.0, alpha: 0.6)
        
        mapView.delegate = self
        
//        createMap()
        
    }
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        if annotation.isKindOfClass(Annotations) {
//            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
//            annoView.pinTintColor = primaryColor
//            annoView.animatesDrop = true
//            
//            return annoView
//        }
//        return nil
//    }
    
//    func createMap() {
//        
//        if let lat = post.pictureLatitude, lon = post.pictureLongitude {
//            mapView.hidden = false
//            lineView.hidden = false
//            
//            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//            
//            let span = MKCoordinateSpanMake(0.01, 0.01)
//            let region = MKCoordinateRegion(center: coordinate!, span: span)
//            
//            mapView.setRegion(region, animated: true)
//            
//            let location = post.pictureLocation
//            
//            let place = Annotations(coordinate: coordinate!, title: location)
//            
//            mapView.addAnnotation(place)
//            mapView.selectAnnotation(place, animated: true)
//            
//        } else {
//            mapView.hidden = true
//            lineView.hidden = true
//        }
//    }
    
}

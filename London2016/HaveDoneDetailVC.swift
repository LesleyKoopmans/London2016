//
//  HaveDoneDetailVC.swift
//  London2016
//
//  Created by Lesley on 04-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class HaveDoneDetailVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var post: Picture!
    var request: Request?
    var coordinate: CLLocationCoordinate2D?
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        loadPost()
        createMap()
        print(post.pictureLatitude)
        print(post.pictureLongitude)
        
    }
    
    @IBAction func pictureTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("HaveDonePictureVC", sender: post)
    }
    
    @IBAction func editBtnTapped() {
        performSegueWithIdentifier("HaveDoneEditVC", sender: post)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HaveDoneEditVC" {
            if let editVC = segue.destinationViewController as? HaveDoneEditVC {
                if let post = sender as? Picture {
                    editVC.itemToEdit = post
                }
            }
        }
        
        if segue.identifier == "HaveDonePictureVC" {
            if let pictureVC = segue.destinationViewController as? HaveDonePictureVC {
                if let post = sender as? Picture {
                    pictureVC.detailedPicture = post
                }
            }
        }
    }
    
    func loadPost() {
        self.navigationItem.title = "\(post.pictureName)"
        descriptionLbl.text = post.pictureDescription
        
        var img: UIImage?
        

        if img != nil {
            self.postImage.image = img
        } else {
            request = Alamofire.request(.GET, post.pictureImage).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        let img = UIImage(data: data!)!
                        self.postImage.image = img
                        self.postImage.clipsToBounds = true
                        HaveDoneVC.imageCache.setObject(img, forKey: self.post.pictureImage)
                    }
            })
                
        }
        img = HaveDoneVC.imageCache.objectForKey(post.pictureImage) as? UIImage
    }
    
    func createMap() {
        
        if let lat = post.pictureLatitude, lon = post.pictureLongitude {
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            
            mapView.setRegion(region, animated: true)
            
            
            let place = Annotations(coordinate: coordinate!)
            
            mapView.addAnnotation(place)
            
        }
        
        
    }
    
}

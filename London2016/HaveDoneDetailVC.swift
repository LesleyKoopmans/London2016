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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lineView: UIView!
    
    var post: Picture!
    var request: Request?
    var coordinate: CLLocationCoordinate2D?
    var pictures = [UIImage]()
    
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        loadPost { (succes) in
            if succes {
                print(self.pictures.count)
                self.addImagesToScrollview()
            }
        }
        
        createMap()
    }
    
    @IBAction func pictureTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("HaveDonePictureVC", sender: post)
        print("tapped")
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
    
    func loadPost(completionHandler: (succes: Bool) -> Void) {
        self.navigationItem.title = "\(post.pictureName)"
        descriptionLbl.text = post.pictureDescription
        
        if let dict = post.pictureDict {
            for img in dict {
                let url = NSURL(string: "\(img.0)")
                
                Alamofire.request(.GET, url!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        let img = UIImage(data: data!)!
                        self.pictures.append(img)
                        completionHandler(succes: false)
                    }
                    completionHandler(succes: true)
                })
            }
        }

        
//        var img: UIImage?
//        
//        if img != nil {
//            self.postImage.image = img
//        } else {
//            request = Alamofire.request(.GET, post.pictureImage).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
//                    if error == nil {
//                        let img = UIImage(data: data!)!
//                        self.postImage.image = img
//                        self.postImage.clipsToBounds = true
//                        HaveDoneVC.imageCache.setObject(img, forKey: self.post.pictureImage)
//                    }
//            })
//        }
//        img = HaveDoneVC.imageCache.objectForKey(post.pictureImage) as? UIImage
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(Annotations) {
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = primaryColor
            annoView.animatesDrop = true
            
            return annoView
        }
        return nil
    }
    
    func createMap() {
        
        if let lat = post.pictureLatitude, lon = post.pictureLongitude {
            mapView.hidden = false
            lineView.hidden = false
            
            coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: coordinate!, span: span)
            
            mapView.setRegion(region, animated: true)
            
            let location = post.pictureLocation
            
            let place = Annotations(coordinate: coordinate!, title: location)
            
            mapView.addAnnotation(place)
            mapView.selectAnnotation(place, animated: true)
            
        } else {
            mapView.hidden = true
            lineView.hidden = true
        }
    }
    
    func addImagesToScrollview() {
        let index = pictures.count
        
        for (index, image) in pictures.enumerate() {
            let imgView = UIImageView(image: image)
            imgView.contentMode = .ScaleAspectFit
            scrollView.addSubview(imgView)
            
            imgView.frame = CGRectMake(-320 + (320 * CGFloat(index + 1)), 0, 320, scrollView.frame.size.height)
        }
        
        scrollView.contentSize = CGSizeMake(320 * CGFloat(index), scrollView.frame.size.height)
    }
}

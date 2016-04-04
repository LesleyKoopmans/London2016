//
//  HaveDoneDetailVC.swift
//  London2016
//
//  Created by Lesley on 04-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import MapKit

class HaveDoneDetailVC: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var post: Picture!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPost()
        
    }
    
    @IBAction func pictureTapped() {
        //Go to scrollview for picture
    }
    
    func loadPost() {
        self.navigationItem.title = "\(post.pictureName)"
        descriptionLbl.text = post.pictureDescription
    }
    
}

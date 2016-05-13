//
//  CustomCollectionViewCell.swift
//  London2016
//
//  Created by Lesley on 11-05-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var post: Picture!
    var request: Request?
    
    func configureCell(img: UIImage?) {
        
        if img != nil {
            self.imageView.image = img
            self.imageView.clipsToBounds = true
        } else {
            self.imageView.image = UIImage(named: "placeholder")
            
        }
        
    }
    
    func changeImage() {
        
    }
    
}

//
//  PictureCell.swift
//  London2016
//
//  Created by Lesley on 02-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire

class PictureCell: UITableViewCell {
    
    @IBOutlet weak var pictureTitle: UILabel!
    @IBOutlet weak var pictureDescription: UITextView!
    @IBOutlet weak var pictureImage: UIImageView!
    
    var post: Picture!
    var request: Request?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Picture, img: UIImage?) {
        self.post = post
        self.pictureTitle.text = post.pictureName
        self.pictureDescription.text = post.pictureDescription
        
        if img != nil {
            self.pictureImage.image = img
            self.pictureImage.clipsToBounds = true
        } else {
            
            request = Alamofire.request(.GET, self.post.pictureImage).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                if error == nil {
                    let img = UIImage(data: data!)!
                    self.pictureImage.image = img
                    self.pictureImage.clipsToBounds = true
                    HaveDoneVC.imageCache.setObject(img, forKey: self.post.pictureImage)
                }
            })
            
        }
    }
    
}

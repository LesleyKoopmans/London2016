//
//  ActivityCell.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var activity: Activity!
    var request: Request?
    
    func configureCell(activity: Activity, img: UIImage?) {
        self.activity = activity
        
        nameLbl.text = self.activity.activityName
        
        if img != nil {
            self.thumbImg.image = img
            self.thumbImg.clipsToBounds = true
        } else {
            
            request = Alamofire.request(.GET, activity.activityImage!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                if error == nil {
                    let img = UIImage(data: data!)!
                    self.thumbImg.image = img
                    self.thumbImg.clipsToBounds = true
                    ToDoVC.imageCache.setObject(img, forKey: self.activity.activityImage!)
                }
            })
            
        }
    }
    
}

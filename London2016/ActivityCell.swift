//
//  ActivityCell.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var activity: Activity!
    
    func configureCell(activity: Activity) {
        self.activity = activity
        
        nameLbl.text = self.activity.name.capitalizedString
        thumbImg.image = UIImage(named: "")
    }
}

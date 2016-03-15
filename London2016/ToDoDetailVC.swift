//
//  ToDoDetailVC.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit

class ToDoDetailVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = activity.name
        descriptionLbl.text = activity.description
        
    }
    
    @IBAction func urlBtnTapped(sender: UIButton) {
        
    }
    
    @IBAction func editBtnTapped(sender: UIButton) {
        performSegueWithIdentifier("ToDoEdit", sender: nil)
    }
}

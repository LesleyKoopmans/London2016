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
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    
    var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    @IBAction func urlBtnTapped(sender: UIButton) {
        
    }
    
    @IBAction func editBtnTapped(sender: UIButton) {
        performSegueWithIdentifier("ToDoEditVC", sender: activity)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDoEditVC" {
            if let editVC = segue.destinationViewController as? ToDoEditVC {
                if let activity = sender as? Activity {
                    editVC.itemToEdit = activity
                }
            }
        }
    }
    
    func loadData() {
        self.navigationItem.title = "\(activity.activityName)".capitalizedString
        
        var img: UIImage?
        
        if let date = activity.activityDate {
            dateLbl.text = date
        } else {
            dateStackView.hidden = true
        }
        
        if let price = activity.activityPrice {
            priceLbl.text = "€\(price) p.p."
        } else {
            priceStackView.hidden = true
        }
        
        if let url = activity.activityImage {
            img = ToDoVC.imageCache.objectForKey(url) as? UIImage
        }
        
        activityImage.image = img
        
        descriptionLbl.text = activity.activityDescription
    }
}

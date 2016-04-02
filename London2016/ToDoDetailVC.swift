//
//  ToDoDetailVC.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire

class ToDoDetailVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var parentStackView: UIStackView!
    @IBOutlet weak var dateParentLbl: UILabel!
    @IBOutlet weak var priceParentLbl: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    var activity: Activity!
    var request: Request?
    
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
        self.navigationItem.title = "\(activity.activityName)"
        
        var img: UIImage?
        
        if let date = activity.activityDate where date != "" {
            dateLbl.text = date
        } else {
            dateStackView.hidden = true
            parentStackView.distribution = .Fill
            priceParentLbl.textAlignment = .Center
            priceLbl.textAlignment = .Center
        }
        
        if let price = activity.activityPrice where price != "" {
            priceLbl.text = "€\(price) p.p."
        } else {
            priceStackView.hidden = true
            parentStackView.distribution = .Fill
            dateParentLbl.textAlignment = .Center
            dateLbl.textAlignment = .Center
        }
        
        if let url = activity.activityImage {
            if img != nil {
                self.activityImage.image = img
            } else {
                
                request = Alamofire.request(.GET, activity.activityImage!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        let img = UIImage(data: data!)!
                        self.activityImage.image = img
                        self.activityImage.clipsToBounds = true
                        ToDoVC.imageCache.setObject(img, forKey: self.activity.activityImage!)
                    }
                })
                
            }
            img = ToDoVC.imageCache.objectForKey(url) as? UIImage
        }
        
        if let websiteBtn = activity.activityUrl where websiteBtn != "" {
            urlButton.setTitle("\(websiteBtn)", forState: .Normal)
        } else {
            urlButton.hidden = true
        }
        
        descriptionLbl.text = activity.activityDescription
    }
}

//
//  ViewController.swift
//  London2016
//
//  Created by Lesley on 14-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "LONDON2016"
        downloadImages()
    }
    
    @IBAction func toDoBtnTapped() {
        performSegueWithIdentifier("ToDoVC", sender: nil)
    }
    
    @IBAction func haveDoneBtnTapped() {
        performSegueWithIdentifier("HaveDoneVC", sender: nil)
    }
    
    func downloadImages() {
        
        DataService.ds.REF_PICTURES.queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        if let imgDict = postDict["images"] as? Dictionary<String, AnyObject> {
                            for img in imgDict {
                                print(img.1)
                            }
                        }
                    }
                }
            }
        })

    }
    
}


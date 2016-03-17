//
//  ViewController.swift
//  London2016
//
//  Created by Lesley on 14-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "LONDON2016"
    }
    
    @IBAction func toDoBtnTapped() {
        performSegueWithIdentifier("ToDoVC", sender: nil)
    }
    
    @IBAction func haveDoneBtnTapped() {
        performSegueWithIdentifier("HaveDoneVC", sender: nil)
    }
    
}


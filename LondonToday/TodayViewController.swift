//
//  TodayViewController.swift
//  LondonToday
//
//  Created by Lesley on 15-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var toDoLbl: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let componets = calendar.components([.Day, .Month, .Year], fromDate: date)
        
        let year = componets.year
        let month = componets.month
        let day = componets.day
        
        toDoLbl.text = "\(day)-\(month)-\(year)"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}

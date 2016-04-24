//
//  ToDoVC.swift
//  London2016
//
//  Created by Lesley on 15-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Firebase

class ToDoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var activities = [Activity]()
    static var imageCache = NSCache()
    var keys = [String]()
    var dates = [String]()
    var dictionary = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        self.navigationItem.title = "TO DO"
        
        loadData { (succes) -> Void in
            if succes {
                self.deleteActivity()
                self.createLocalNotification()
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let activity = activities[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCell", forIndexPath: indexPath) as? ActivityCell {
            
            cell.request?.cancel()
            
            var img = UIImage(named: "placeholder")
            
            if let url = activity.activityImage {
                img = ToDoVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(activity, img: img)
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            
            loadingIndicator.stopAnimating()
            loadingIndicator.hidden = true
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let activity = activities[indexPath.row]
        
        performSegueWithIdentifier("ToDoDetailVC", sender: activity)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(135, 135)
    }
    
    @IBAction func addBtnTapped(sender: AnyObject) {
        performSegueWithIdentifier("ToDoCreateVC", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToDoDetailVC" {
            if let detailsVC = segue.destinationViewController as? ToDoDetailVC {
                if let activity = sender as? Activity {
                    detailsVC.activity = activity
                }
            }
        }
    }
    
    func loadData(completionHandler: (succes: Bool) -> Void) {

        loadingIndicator.startAnimating()
        completionHandler(succes: false)
        DataService.ds.REF_ACTIVITY.queryOrderedByChild("sortOrder").observeEventType(.Value, withBlock: { snapshot in
            self.activities = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        
                        let activity = Activity(activityKey: key, dictionary: postDict)
                        self.activities.append(activity)
                        
                        if let date = postDict["date"] {
                            self.keys.append(key)
                            self.dates.append(date as! String)
                            
                            for(index, element) in self.keys.enumerate() {
                                self.dictionary[element] = self.dates[index]
                            }
                            completionHandler(succes: true)
                        }
                    }
                    
                }
                
            }
            
            self.collection.reloadData()
        })
    }
    
    func deleteActivity() {
        let currentDate = NSDate()
        for item in dictionary {
            let date = item.1
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if var nsDate = formatter.dateFromString(date) {
                nsDate = nsDate.dateByAddingTimeInterval(60*60*24*1)
                switch currentDate.compare(nsDate) {
                case .OrderedDescending:
                    
                    let fireDate = nsDate.dateByAddingTimeInterval(60*60*1)
                    
                    DataService.ds.REF_ACTIVITY.childByAppendingPath(item.0).observeEventType(.Value, withBlock: { snapshot in
                        if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                            let title = postDict["name"] as! String
                            
                            let notification = UILocalNotification()
                            notification.alertTitle = "Foto plaastsen?"
                            notification.alertBody = "Was het leuk bij \(title)? Plaats anders even een foto!"
                            notification.fireDate = fireDate
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                            
                        }
                    })
                    
                    let postRef = DataService.ds.REF_ACTIVITY.childByAppendingPath(item.0)
                    postRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                        postRef.removeValue()
                    })
                    break
                case .OrderedSame: break
                default: break
                }
                
            }
            
        }
    }
    
    func createLocalNotification() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = NSDate()
        let now = dateFormatter.stringFromDate(currentDate)
        
        for item in dictionary {
            let date = item.1
            
            if now == date {
                
                if let nsDate = dateFormatter.dateFromString(date) {
                    let fireDate = nsDate.dateByAddingTimeInterval(60*60*15)
                    let currentDate = NSDate()
                    
                    DataService.ds.REF_ACTIVITY.childByAppendingPath(item.0).observeEventType(.Value, withBlock: { snapshot in
                        if let postDict = snapshot.value as? Dictionary<String, AnyObject> {
                            let title = postDict["name"] as! String
                            
                            switch currentDate.compare(nsDate) {
                            case .OrderedDescending:
                                print("Currentdate is later")
                            case .OrderedSame:
                                self.fireNotification(title, fireDate: fireDate)
                            case .OrderedAscending:
                                self.fireNotification(title, fireDate: fireDate)
                            }
                            
                            
                        }
                    })
                }
            }
        }
    }
    
    func fireNotification(activityTitle: String, fireDate: NSDate) {
        let notification = UILocalNotification()
        notification.alertTitle = "Yeah! Feestje!"
        notification.alertBody = "Veel plezier vandaag bij \(activityTitle)"
        notification.fireDate = fireDate
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}

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
    
    var activities = [Activity]()
    static var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        self.navigationItem.title = "TO DO"
        
        DataService.ds.REF_ACTIVITY.observeEventType(.Value, withBlock: { snapshot in
            self.activities = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        
                        let activity = Activity(activityKey: key, dictionary: postDict)
                        self.activities.append(activity)
                    }
                    
                }
                
            }
            
            self.collection.reloadData()
        })
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let activity = activities[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ActivityCell", forIndexPath: indexPath) as? ActivityCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = activity.activityImage {
                img = ToDoVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(activity, img: img)
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
        return CGSizeMake(120, 120)
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
    
}

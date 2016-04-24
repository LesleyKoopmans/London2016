//
//  HaveDoneVC.swift
//  London2016
//
//  Created by Lesley on 02-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Firebase

class HaveDoneVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var posts = [Picture]()
    static var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Have Done"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PictureCell", forIndexPath: indexPath) as? PictureCell {
            
            cell.request?.cancel()
            var img = UIImage(named: "placeholder")
            
            img = HaveDoneVC.imageCache.objectForKey(post.pictureImage) as? UIImage
            
            
            cell.configureCell(post, img: img)
            cell.cornerRadius = 5
            cell.clipsToBounds = true
            
            loadingIndicator.stopAnimating()
            loadingIndicator.hidden = true
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = posts[indexPath.row]
        
        performSegueWithIdentifier("HaveDoneDetailVC", sender: post)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func loadData() {
        
        loadingIndicator.startAnimating()
        
        DataService.ds.REF_PICTURES.queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in

            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        
                        let post = Picture(postKey: key, dictionary: postDict)
                        self.posts.insert(post, atIndex: 0)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addBtnTapped() {
        performSegueWithIdentifier("HaveDoneCreateVC", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HaveDoneDetailVC" {
            if let detailVC = segue.destinationViewController as? HaveDoneDetailVC {
                if let post = sender as? Picture {
                    detailVC.post = post
                }
            }
        }
    }
}

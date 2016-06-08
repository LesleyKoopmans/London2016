//
//  HaveDoneDetailVC.swift
//  London2016
//
//  Created by Lesley on 04-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class HaveDoneDetailVC: UIViewController, UIPageViewControllerDataSource {
    
    //VARIABLES AND LETS
    var post: Picture!
    var request: Request?
    var pictures = [String:UIImage]()
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageTitles = [String]()
        pageImages = [UIImage]()
        
        loadPost { (succes) in
            if succes {
                self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
                
                let startVC = self.viewControllerAtIndex(0) as ContentViewController
                let viewControllers = NSArray(object: startVC)
                
                self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
                self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                self.addChildViewController(self.pageViewController)
                self.view.addSubview(self.pageViewController.view)
                self.pageViewController.didMoveToParentViewController(self)
            }
        }
        
        
        
        self.pageViewController.dataSource = self
        
//        let startVC = viewControllerAtIndex(0) as ContentViewController
//        let viewControllers = NSArray(object: startVC)
//        
//        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
//        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
//        self.addChildViewController(self.pageViewController)
//        self.view.addSubview(self.pageViewController.view)
//        self.pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func pictureTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("HaveDonePictureVC", sender: post)
    }
    
    @IBAction func editBtnTapped() {
        performSegueWithIdentifier("HaveDoneEditVC", sender: post)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HaveDoneEditVC" {
            if let editVC = segue.destinationViewController as? HaveDoneEditVC {
                if let post = sender as? Picture {
                    editVC.itemToEdit = post
                }
            }
        }
        
        if segue.identifier == "HaveDonePictureVC" {
            if let pictureVC = segue.destinationViewController as? HaveDonePictureVC {
                if let post = sender as? Picture {
                    pictureVC.detailedPicture = post
                }
            }
        }
    }
    
    func loadPost(completionHandler: (succes: Bool) -> Void) {
        self.navigationItem.title = "\(post.pictureName)"
        
        if let dict = post.pictureDict {
            for img in dict {
                completionHandler(succes: false)
                let url = NSURL(string: "\(img.0)")
                Alamofire.request(.GET, url!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                    if error == nil {
                        let value = UIImage(data: data!)!
                        let key = img.1
                        self.pictures["\(key)"] = value
                        self.pageImages.append(value)
                    }
                })
                
            }
            
        }
        completionHandler(succes: true)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return ContentViewController()
        }
        
        let vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        vc.imageFile = self.pageImages[index]
        vc.titleText = self.pageTitles[index] as? String
        vc.pageIndex = index
        
        return vc
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        index = index - 1
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index + 1
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
}

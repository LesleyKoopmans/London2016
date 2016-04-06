//
//  HaveDonePictureVC.swift
//  London2016
//
//  Created by Lesley on 05-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire

class HaveDonePictureVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var detailedPicture: Picture!
    var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        scrollView.contentOffset = CGPoint(x: 1000, y: 450)
        scrollView.delegate = self
        
        setZoomScale()
        
        loadItem()
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillLayoutSubviews() {
        setZoomScale()
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min (widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    func loadItem() {
        var img: UIImage?
        
        if img != nil {
            self.imageView.image = img
        } else {
            request = Alamofire.request(.GET, detailedPicture.pictureImage).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
                if error == nil {
                    let img = UIImage(data: data!)!
                    self.imageView.image = img
                    self.imageView.clipsToBounds = true
                    HaveDoneVC.imageCache.setObject(img, forKey: self.detailedPicture.pictureImage)
                }
            })
            
        }
        img = HaveDoneVC.imageCache.objectForKey(detailedPicture.pictureImage) as? UIImage
        
    }
    
}

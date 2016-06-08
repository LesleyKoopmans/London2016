//
//  HaveDonePictureVC.swift
//  London2016
//
//  Created by Lesley on 05-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class HaveDonePictureVC: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopContstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var detailedPicture: Picture!
    var request: Request?
    var imagePicker: UIImagePickerController!
    var imageDictCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        scrollView.contentOffset = CGPoint(x: 1000, y: 450)
        scrollView.contentSize = imageView.bounds.size
        scrollView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        scrollViewDidZoom(scrollView)
        setupGestureRecognizer()
        
        var img = UIImage(named: "placeholder")
        img = HaveDoneVC.imageCache.objectForKey(detailedPicture.pictureImage) as? UIImage
        
        imageView.image = img
        
        imageDictCount = detailedPicture.pictureDict?.count
        
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
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = 1.0
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(HaveDonePictureVC.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    @IBAction func addPictureTapped() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dataImage = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1.0)!
        let img = UIImage(data: dataImage)!
        
        imagePicker.sourceType = .PhotoLibrary
        
        imageView.image = img
        
        if let img = imageView.image {
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlStr)!
            let imgData = UIImageJPEGRepresentation(img, 0.2)!
            let keyData = "389CIJPV7ede49f95a967a77e48a44c0aa697929".dataUsingEncoding(NSUTF8StringEncoding)!
            let keyJSON = "json".dataUsingEncoding(NSUTF8StringEncoding)!
            
            Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                
                multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpg")
                multipartFormData.appendBodyPart(data: keyData, name: "key")
                multipartFormData.appendBodyPart(data: keyJSON, name: "format")
                
            }) { encodingResult in
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON(completionHandler: { response in
                        if let info = response.result.value as? Dictionary<String, AnyObject> {
                            
                            if let links = info["links"] as? Dictionary<String, AnyObject> {
                                
                                if let imgLink = links["image_link"] as? String {
                                    self.postToFirebase(imgLink)
                                }
                            }
                        }
                    })
                    
                case .Failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "Mislukt", message: "Die verdomde error die ik nog niet kan verhelpen!", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            
        } else {
            print("Upload zonder foto")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func postToFirebase(imgUrl: String) {
        let postRef = DataService.ds.REF_PICTURES.childByAppendingPath("\(self.detailedPicture.pictureKey)/images")
                
        let imagePlace = imageDictCount + 1
        postRef.updateChildValues(["image\(imagePlace)": imgUrl])
        
        imageDictCount = imageDictCount + 1
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
}

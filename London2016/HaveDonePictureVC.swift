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

class HaveDonePictureVC: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var detailedPicture: Picture!
    var request: Request?
    var imagePicker: UIImagePickerController!
    var firstImg: UIImage!
    var newImg: UIImage?
    var alertController = UIAlertController()
    var imageDictCount: Int!
    var imageDict = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        loadPictureData { (succes) -> Void in
            if succes {
                self.loadItem()
                self.collectionView.reloadData()
            }
        }
        
        imageDictCount = detailedPicture.pictureDict?.count
        
        
    }
    
    func loadItem() {
        
//        for (index, item) in imageDict.enumerate() {
//            request = Alamofire.request(.GET, item.1).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, error in
//                if error == nil {
//                    
//                    let img = UIImage(data: data!)!
//                    let imgView = UIImageView(image: img)
//                    
//                    self.scrollView.addSubview(imgView)
//                    
//                    imgView.frame = CGRectMake((320 * CGFloat(index)), 0, 320, 504)
//                    
////                    self.firstImg = UIImage(data: data!)!
////                    self.imageView.image = self.firstImg
////                    self.imageView.clipsToBounds = true
////                    HaveDoneVC.imageCache.setObject(self.firstImg, forKey: self.detailedPicture.pictureImage)
//                }
//                
//                self.scrollView.contentSize = CGSizeMake(320 * CGFloat(self.imageDictCount), 504)
//            })
//
//        }
    }
    
    @IBAction func addPhotoTapped() {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.sourceType = .PhotoLibrary
        let dataImage = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1.0)!
        
        newImg = UIImage(data: dataImage)!
        
        let imageView = UIImageView(image: newImg)
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        imageView.backgroundColor = UIColor.blackColor()
        imageView.contentMode = .ScaleAspectFit
        
        view.addSubview(imageView)
        
        dismissViewControllerAnimated(true, completion: nil)
        
        alertController = UIAlertController(title: "Toevoegen?", message: "Wilt u deze foto toevoegen aan de huidige foto?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Annuleer", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Toevoegen", style: .Default, handler: {(alert: UIAlertAction!) in self.uploadImage()})
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func uploadImage() {
        if let img = newImg {
            let urlStr = "https://post.imageshack.us/upload_api.php"
            let url = NSURL(string: urlStr)!
            let imgData = UIImageJPEGRepresentation(img, 0.6)!
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
                            
                        } else {
                            self.alertController = UIAlertController(title: "Mislukt", message: "Die verdomde error die ik nog niet kan verhelpen!", preferredStyle: .Alert)
                            let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            self.alertController.addAction(cancelAction)
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(self.alertController, animated: true, completion: nil)
                            })
                        }
                    })
                    
                case .Failure(let error):
                    print(error)
                }
            }
            
        } else {
            print("Upload zonder foto")
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let postRef = DataService.ds.REF_PICTURES.childByAppendingPath("\(self.detailedPicture.pictureKey)/images")
        
        
        let imagePlace = imageDict.count + 1
        print(imagePlace)
        postRef.updateChildValues(["image\(imagePlace)": imgUrl])
        
        imageDictCount = imageDictCount + 1
        
    }
    
    func loadPictureData(completionHandler: (succes: Bool) -> Void) {
        
        DataService.ds.REF_PICTURES.queryOrderedByChild("date").observeEventType(.Value, withBlock: { snapshot in
            completionHandler(succes: false)
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        if key == self.detailedPicture.pictureKey {
                            
                            if let images = postDict["images"] as? Dictionary<String,String> {
                                for img in images {
                                    if let url = NSURL(string: "\(img.1)") {
                                        if let data = NSData(contentsOfURL: url) {
                                            if let img = UIImage(data: data) {
                                                self.imageDict.append(img)
                                            }
                                        }
                                        
                                    }
                                }
                            } 
                        }
                    }
                }
                completionHandler(succes: true)
            }
            
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDict.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let post = imageDict[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCell", forIndexPath: indexPath) as? CustomCollectionViewCell {
            
            var img = UIImage(named: "placeholder")
            
            img = post
            
            cell.configureCell(img)
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    
}

//
//  HaveDoneEditVC.swift
//  London2016
//
//  Created by Lesley on 04-04-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary
import Photos
import CoreLocation

class HaveDoneEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    var itemToEdit: Picture?
    var alertController = UIAlertController()
    var dateTime: String?
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imageView.clipsToBounds = true
        
        titleField.delegate = self
        descriptionField.delegate = self
        locationField.delegate = self
        
        descriptionFieldInit()
        setupAlertController()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addBtnTapped() {
        uploadImage()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelBtnTapped(sender: UIButton) {
        if itemToEdit != nil {
            let postRef = DataService.ds.REF_PICTURES.childByAppendingPath("\(self.itemToEdit!.pictureKey)")
            
            postRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                postRef.removeValue()
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                
            })
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func descriptionFieldInit() {
        descriptionField.text = "Omschrijving"
        descriptionField.textColor = placeholderColor
        descriptionField.font = UIFont(name: "Verdana", size: 14.0)
        descriptionField.textAlignment = .Center
        descriptionField.editable = true
        descriptionField.textContainer.maximumNumberOfLines = 2
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionField.textColor == placeholderColor {
            descriptionField.text = nil
            descriptionField.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionField.text.isEmpty {
            descriptionField.text = "Omschrijving"
            descriptionField.textColor = placeholderColor
        }
    }
    
    func postToFirebase(imgUrl: String) {
        if itemToEdit != nil {
            let postRef = DataService.ds.REF_PICTURES.childByAppendingPath("\(self.itemToEdit!.pictureKey)")
            
            var post: Dictionary<String, AnyObject> = [
                "name": titleField.text!,
                "description": descriptionField.text!,
                "images": [
                    "image1": imgUrl
                ]
            ]
            
            if locationField.text != nil {
                post["location"] = locationField.text
            }
            
            if dateTime != nil {
                post["date"] = dateTime
            }
            
            if longitude != nil {
                post["longitude"] = longitude
            }
            
            if latitude != nil {
                post["latitude"] = latitude
            }
            
            postRef.updateChildValues(post)
            
        } else {
            var post: Dictionary<String, AnyObject> = [
                "name": titleField.text!,
                "description": descriptionField.text!,
                "images": [
                    "image1": imgUrl
                ]
            ]
            
            if locationField.text != nil {
                post["location"] = locationField.text
            }
            
            if dateTime != nil {
                post["date"] = dateTime
            }
            
            if longitude != nil {
                post["longitude"] = longitude
            }
            
            if latitude != nil {
                post["latitude"] = latitude
            }
            
            let firebasePost = DataService.ds.REF_PICTURES.childByAutoId()
            firebasePost.setValue(post)
        }
        
        titleField.text = ""
        descriptionField.text = ""
        imageView.image = UIImage(named: "placeholder")
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.pictureName
            descriptionField.text = item.pictureDescription
            descriptionField.textColor = UIColor.blackColor()
            
            if let location = item.pictureLocation {
                locationField.text = location
            }
            
            imageView.image = HaveDoneVC.imageCache.objectForKey(item.pictureImage) as? UIImage
        }
        urlBtn.setTitle("Wijzig", forState: .Normal)
    }
    
    func setupAlertController() {
        self.alertController = UIAlertController(title: "Selecteer foto", message: nil, preferredStyle: .ActionSheet)
        let camera = UIAlertAction(title: "Camera", style: .Default) { (UIAlertAction) -> Void in
            self.photoFromCamera()
        }
        
        let imageGallery = UIAlertAction(title: "Gallerij", style: .Default) {
            (UIAlertAction) -> Void in
            self.photoFromImageGallery()
        }
        
        let cancel = UIAlertAction(title: "Annuleer", style: .Cancel, handler: nil)
        
        self.alertController.addAction(camera)
        self.alertController.addAction(imageGallery)
        self.alertController.addAction(cancel)
    }
        
    func photoFromCamera() {
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func photoFromImageGallery() {
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let dataImage = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1.0)!
        let img: UIImage = UIImage(data: dataImage)!
        
        if imagePicker.sourceType == .Camera {
            let metaData = info[UIImagePickerControllerMediaMetadata] as? NSDictionary
            
            if metaData != nil {
                let tiff = metaData!["{TIFF}"] as? NSDictionary
                
                if tiff != nil {
                    let date = tiff!["DateTime"] as? String
                    
                    if let time = date where time != "" {
                        dateTime = changeDate(time)
                    }
                }
            }

        } else if imagePicker.sourceType == .PhotoLibrary {
            let referenceUrl: NSURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let result: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([referenceUrl], options: nil)
            
            let img = info[UIImagePickerControllerOriginalImage] as! UIImage
            let size = img.size
            
            let asset: PHAsset = result.firstObject as! PHAsset
            
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: .AspectFill, options: nil, resultHandler: { (img, info) -> Void in
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                
                if let nsDate = asset.creationDate where nsDate != "" {
                    let date = dateFormatter.stringFromDate(nsDate)
                    self.dateTime = date
                }
                
                if let position = asset.location where position != "" {
                    let coordinate = position.coordinate
                    
                    let lat = coordinate.latitude
                    self.latitude = lat
                    let lon = coordinate.longitude
                    self.longitude = lon
                    
                } else {
                    print("No Location")
                }
            })
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        imageView.image = img
    }
    
    func changeDate(string: String) -> String {
        
        print(string)
        
        let str = string.stringByReplacingOccurrencesOfString(":", withString: "")
        let value = String(str.characters.dropLast(7))
        
        return value
    }

    func uploadImage() {
        if let img = imageView.image {
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
}

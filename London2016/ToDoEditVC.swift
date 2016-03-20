//
//  ToDoEditVC.swift
//  London2016
//
//  Created by Lesley on 18-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class ToDoEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionField.delegate = self
        descriptionField.text = "Description"
        descriptionField.textColor = UIColor.darkGrayColor()
        descriptionField.font = UIFont(name: "Verdana", size: 14.0)
        descriptionField.textAlignment = .Center
        descriptionField.editable = true
        
        imageView.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        titleField.delegate = self
        priceField.delegate = self
        urlField.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func dateSelection(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        datePicker.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imagePicker.sourceType = .PhotoLibrary
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = img
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionField.textColor == UIColor.darkGrayColor() {
            descriptionField.text = nil
            descriptionField.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionField.text.isEmpty {
            descriptionField.text = "Description"
            descriptionField.textColor = UIColor.lightGrayColor()
        }
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addBtnTapped(sender: UIButton) {
        if let txt = titleField.text where txt != "" {
            
            if let img = imageView.image {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.8)!
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
                                        
                                        if let imgLink = links["image"] as? String {
                                            self.postToFirebase(imgLink)
                                        }
                                        
                                    }
                                    
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
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func postToFirebase(imgUrl: String) {
        var post: Dictionary<String, AnyObject> = [
            "title": titleField.text!,
            "description": descriptionField.text!,
            "image": imgUrl
        ]
            
        if datePicker.text != nil {
            post["date"] = datePicker.text
        }
        
        if priceField.text != nil {
            post["price"] = priceField.text
        }
        
        if urlField.text != nil {
            post["url"] = urlField.text
        }
        
        let firebasePost = DataService.ds.REF_ACTIVITY.childByAutoId()
        firebasePost.setValue(post)
        
        titleField.text = ""
        descriptionField.text = ""
        imageView.image = UIImage(named: "placeholder")
    }
    
}

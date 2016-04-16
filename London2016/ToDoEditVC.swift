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
import EventKit

class ToDoEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var datePicker: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    var itemToEdit: Activity?
    let eventStore = EKEventStore()
    var calendarDate: NSDate?
    var eventId: NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        titleField.delegate = self
        priceField.delegate = self
        descriptionField.delegate = self
        urlField.delegate = self
        
        descriptionFieldInit()
        
        checkAccessToCalendar()
        
        if itemToEdit != nil {
            loadItemData()
        } 
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
        datePickerView.addTarget(self, action: #selector(ToDoEditVC.datePickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        if let item = itemToEdit {
            if let date = item.activityDate where date != "" {
                let nsDate = changeDate(date)
                datePickerView.date = nsDate
            }
        }
        
    }
    
    func changeDate(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let nsDate = dateFormatter.dateFromString(string)
        
        return nsDate!
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "fr_FR")
        dateFormatter.timeStyle = .NoStyle
        datePicker.text = dateFormatter.stringFromDate(sender.date)
        
        calendarDate = dateFormatter.dateFromString(datePicker.text!)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imagePicker.sourceType = .PhotoLibrary
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = img
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
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnTapped(sender: UIButton) {
        if itemToEdit != nil {
            let postRef = DataService.ds.REF_ACTIVITY.childByAppendingPath("\(self.itemToEdit!.activityKey)")
            
            postRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                postRef.removeValue()
                self.deleteEvent(self.eventStore)
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
                
            })
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func addBtnTapped(sender: UIButton) {
        
        uploadImage()
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func postToFirebase(imgUrl: String) {
        if itemToEdit != nil {
            let postRef = DataService.ds.REF_ACTIVITY.childByAppendingPath("\(self.itemToEdit!.activityKey)")
            
            var post: Dictionary<String, AnyObject> = [
                "name": titleField.text!,
                "description": descriptionField.text!,
                "imageUrl": imgUrl
            ]
            
            if datePicker.text != nil {
                post["date"] = datePicker.text
                
                let date = datePicker.text
                
                let newDate = removeString(date!)
                
                post["sortOrder"] = newDate
                
                insertEvent(eventStore)
                
                post["eventId"] = eventId
                
            }
            
            if datePicker.text == "" {
                post["sortOrder"] = "1231"
                deleteEvent(eventStore)
            }
            
            print(datePicker.text)
            
            if priceField.text != nil {
                post["price"] = priceField.text
            }
            
            if urlField.text != nil {
                post["url"] = urlField.text
            }

            
            postRef.updateChildValues(post)
            
        } else {
            var post: Dictionary<String, AnyObject> = [
                "name": titleField.text!,
                "description": descriptionField.text!,
                "imageUrl": imgUrl
            ]
            
            print(datePicker.text)
            
            if datePicker.text != nil {
                post["date"] = datePicker.text
                
                let date = datePicker.text
                
                let newDate = removeString(date!)
                
                post["sortOrder"] = newDate
                
                insertEvent(eventStore)
                
                post["eventId"] = eventId
            }
            
            if datePicker.text == "" {
                post["sortOrder"] = "1231"
            }
            
            if priceField.text != nil {
                post["price"] = priceField.text
            }
            
            if urlField.text != nil {
                post["url"] = urlField.text
            }
            
            let firebasePost = DataService.ds.REF_ACTIVITY.childByAutoId()
            firebasePost.setValue(post)
        }
        
        titleField.text = ""
        descriptionField.text = ""
        imageView.image = UIImage(named: "placeholder")
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.activityName
            descriptionField.text = item.activityDescription
            descriptionField.textColor = UIColor.blackColor()
            
            if let date = item.activityDate {
                datePicker.text = date
                datePicker.insertText(date)
            }
            
            if let price = item.activityPrice {
                priceField.text = price
            }
            
            if let url = item.activityUrl {
                urlField.text = url
            }
            
            eventId = item.eventId
            
            var img: UIImage?
            
            if let imgUrl = item.activityImage {
                img = ToDoVC.imageCache.objectForKey(imgUrl) as? UIImage
                imageView.image = img
            }
            
        }
        
        urlBtn.setTitle("Wijzig", forState: .Normal)
    }
    
    func removeString(string: String) -> String {
        let newStr = string.stringByReplacingOccurrencesOfString("/", withString: "")
        
        let year = String(newStr.characters.prefix(4))
        
        let firstTwo = String(year.characters.prefix(2))
        let addFirstTwo = year + String(firstTwo)
        let tussen = String(addFirstTwo.characters.dropFirst())
        let endResult = String(tussen.characters.dropFirst())
        
        return endResult
        
    }
    
    func descriptionFieldInit() {
        descriptionField.text = "Omschrijving"
        descriptionField.textColor = placeholderColor
        descriptionField.font = UIFont(name: "Verdana", size: 14.0)
        descriptionField.textAlignment = .Center
        descriptionField.editable = true
        descriptionField.textContainer.maximumNumberOfLines = 2
    }
    
    func uploadImage() {
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
                }
            }
            
        } else {
            print("Upload zonder foto")
        }

    }
    
    func checkAccessToCalendar() {
        
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        
        case .Authorized:
            print("Agenda toegestaan")
        
        case .Denied:
            print("Access denied")
            
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (granted: Bool, error: NSError?) -> Void in
                if granted {
                    self.insertEvent(self.eventStore)
                } else {
                    print("Access Denied")
                }
            })
        default:
            print("Case Default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        let calendars = store.calendarsForEntityType(EKEntityType.Event) as [EKCalendar]
        
        for calendar in calendars {
            if calendar.title == "Inge&Lesley" {
                if calendarDate != nil {
                    let endDate = calendarDate!.dateByAddingTimeInterval(1 * 60 * 60)
                    
                    let event = EKEvent(eventStore: store)
                    event.calendar = calendar
                    
                    if let title = titleField.text {
                        event.title = title
                    }
                    
                    if let notes = descriptionField.text {
                        event.notes = notes
                    }
                    
                    event.startDate = calendarDate!
                    event.endDate = endDate
                    event.allDay = true
                    
                    do {
                        try store.saveEvent(event, span: .ThisEvent, commit: true)
                        eventId = event.eventIdentifier
                    } catch {
                        print("Kan het evenement niet in iOS Calendar zetten")
                    }
                }
                
            }
        }
    }
    
    func deleteEvent(store: EKEventStore) {
        let calendars = store.calendarsForEntityType(EKEntityType.Event) as [EKCalendar]
        
        for calendar in calendars {
            if calendar.title == "London2016" {
                
                if let id = eventId where id != "" {
                    let event = store.eventWithIdentifier(eventId! as String)
                    
                    do {
                        try eventStore.removeEvent(event!, span: EKSpan.ThisEvent)
                    } catch {
                        print("Kon evenement niet verwijderen van iOS Calendar")
                    }
                    
                }
            }
        }
    }

}

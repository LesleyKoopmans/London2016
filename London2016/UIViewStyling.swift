//
//  UIViewStyling.swift
//  London2016
//
//  Created by Lesley on 14-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    public override func awakeFromNib() {
        self.layer.cornerRadius = cornerRadius
        
        if materialKey {
            self.layer.shadowOpacity = 0.8
            self.layer.shadowRadius = 3.0
            self.layer.shadowOffset = CGSizeMake(2.0, 2.0)
            self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
            self.layer.masksToBounds = false
        } else {
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0
            self.layer.shadowColor = nil
            self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
            self.layer.masksToBounds = true
        }
        
    }
    
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSizeMake(10.0, 10.0)
                self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
                self.layer.masksToBounds = false
            } else {
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
                self.layer.shadowOffset = CGSizeMake(0.0, 0.0)
                self.layer.masksToBounds = true
            }
        }
    }
    
}

extension UINavigationBar {
    var castShadow: String {
        get {
            return "anything fake"
        }
        set {
            self.layer.shadowOffset = CGSizeMake(0.0, 5.0)
            self.layer.shadowRadius = 3.0
            self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
            self.layer.shadowOpacity = 0.8
            self.layer.masksToBounds = false
        }
    }
}

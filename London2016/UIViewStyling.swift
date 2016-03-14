//
//  UIViewStyling.swift
//  London2016
//
//  Created by Lesley on 14-03-16.
//  Copyright © 2016 Lesley. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable public var cornerRadius: CGFloat {
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
    }
    
}

//
//  PNPHighlightButton.swift
//  UIComponents
//
//  Created by Hugh Bellamy on 14/06/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//
import UIKit

@IBDesignable
class PNPHighlightButton: UIButton {
    private var normalBackgroundColor: UIColor!
    
    @IBInspectable var highlightedBackgroundColor: UIColor = UIColor.lightGrayColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        normalBackgroundColor = backgroundColor
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = highlightedBackgroundColor
            } else {
                backgroundColor = normalBackgroundColor
            }
        }
    }
}

//
//  NKVFlagView.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 23.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

import UIKit

//protocol NKVFlagViewType {
//    <#requirements#>
//}

final class NKVFlagView: UIView {
    let iconWidth: CGFloat = 18.0
    let shift: CGFloat = 7.0
    let fontCorrection: CGFloat = 1.0
    
    var flagButton: UIButton = UIButton()
    weak var textField: UITextField!
    
    required init(with textField: UITextField) {
        self.textField = textField
        super.init(frame: CGRect.zero)
        configureInstance()
    }
    
    private func configureInstance() {
        // Setting frame
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: (shift * 2) + iconWidth,
                            height: textField.frame.height)
        
        // Adding flag button
        self.flagButton = UIButton.init(frame: self.frame)
        self.flagButton.imageEdgeInsets = UIEdgeInsetsMake(shift, shift, shift, shift);
        self.flagButton.setImage(UIImage(named: "ae"), for: .normal)
        self.flagButton.contentMode = .scaleAspectFit
        self.addSubview(flagButton)
        
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) not supported"); }
}

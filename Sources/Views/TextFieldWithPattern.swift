
//  TextFieldPatternFormat.swift
//  Created by Vojta Stavik
//  Copyright (c) 2016 www.vojtastavik.com All rights reserved.

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

enum TextFieldFormatting {
    case socialSecurityNumber
    case phoneNumber
    case custom
    case noFormatting
}

open class TextFieldPatternFormat: UITextField {
    
    /**
     Set a formatting pattern for a number and define a replacement string. For example: If formattingPattern would be "##-##-AB-##" and
     replacement string would be "#" and user input would be "123456", final string would look like "12-34-AB-56"
     */
    func setFormatting(_ formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
    }
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    var replacementChar: Character = "*"
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    var secureTextReplacementChar: Character = "\u{25cf}"
    
    /**
     Max length of input string. You don't have to set this if you set formattingPattern.
     If 0 -> no limit.
     */
    var maxLength = 0
    
    /**
     Type of predefined text formatting. (You don't have to set this. It's more a future feature)
     */
    var formatting : TextFieldFormatting = .noFormatting {
        didSet {
            switch formatting {
                
            case .socialSecurityNumber:
                self.formattingPattern = "***-**–****"
                self.replacementChar = "*"
                
            case .phoneNumber:
                self.formattingPattern = "***-***–****"
                self.replacementChar = "*"
                
            default:
                self.maxLength = 0
            }
        }
    }
    
    /**
     String with formatting pattern for the text field.
     */
    var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.characters.count
            self.formatting = .custom
        }
    }
    
    /**
     Provides secure text entry but KEEPS formatting. All digits are replaced with the bullet character \u{25cf} .
     */
    var formatedSecureTextEntry: Bool {
        set {
            _formatedSecureTextEntry = newValue
            super.isSecureTextEntry = false
        }
        
        get {
            return _formatedSecureTextEntry
        }
    }
    
    override open var text: String! {
        set {
            super.text = newValue
            textDidChange() // format string properly even when it's set programatically
        }
        
        get {
            if case .noFormatting = formatting {
                return super.text
            } else {
                // Because the UIControl target action is called before NSNotificaion (from which we fire our custom formatting), we need to
                // force update finalStringWithoutFormatting to get the latest text. Otherwise, the last character would be missing.
                textDidChange()
                return finalStringWithoutFormatting
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerForNotifications()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Final text without formatting characters (read-only)
     */
    var finalStringWithoutFormatting : String {
        return TextFieldPatternFormat.makeOnlyDigitsString(_textWithoutSecureBullets)
    }
    
    
    // MARK: - class methods
    class func makeOnlyDigitsString(_ string: String) -> String {
        let stringArray = string.components(separatedBy: CharacterSet.whitespaces)
        let allNumbers = stringArray.joined(separator: "")
        return allNumbers
    }
    
    // MARK: - INTERNAL
    fileprivate var _formatedSecureTextEntry = false
    
    // if secureTextEntry is false, this value is similar to self.text
    // if secureTextEntry is true, you can find final formatted text without bullets here
    fileprivate var _textWithoutSecureBullets = ""
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TextFieldPatternFormat.textDidChange), name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"), object: self)
    }
    
    func textDidChange() {
        
        // TODO: - Isn't there more elegant way how to do this?
        let currentTextForFormatting: String
        
        if super.text?.characters.count > _textWithoutSecureBullets.characters.count {
            currentTextForFormatting = _textWithoutSecureBullets + super.text!.substring(from: super.text!.characters.index(super.text!.startIndex, offsetBy: _textWithoutSecureBullets.characters.count))
        } else if super.text?.characters.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            currentTextForFormatting = _textWithoutSecureBullets.substring(to: _textWithoutSecureBullets.characters.index(_textWithoutSecureBullets.startIndex, offsetBy: super.text!.characters.count))
        }
        
        if formatting != .noFormatting && currentTextForFormatting.characters.count > 0 && formattingPattern.characters.count > 0 {
            let tempString = TextFieldPatternFormat.makeOnlyDigitsString(currentTextForFormatting)
            
            var finalText = ""
            var finalSecureText = ""
            
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                
                if formattingPattern.substring(with: formattingPatternRange) != String(replacementChar) {
                    finalText = finalText + formattingPattern.substring(with: formattingPatternRange)
                    finalSecureText = finalSecureText + formattingPattern.substring(with: formattingPatternRange)
                } else if tempString.characters.count > 0 {
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                    
                    finalText = finalText + tempString.substring(with: pureStringRange)
                    
                    // we want the last number to be visible
                    if tempString.index(tempIndex, offsetBy: 1) == tempString.endIndex {
                        finalSecureText = finalSecureText + tempString.substring(with: pureStringRange)
                    } else {
                        finalSecureText = finalSecureText + String(secureTextReplacementChar)
                    }
                    
                    tempIndex = tempString.index(after: tempIndex)
                }
                
                formatterIndex = formattingPattern.index(after: formatterIndex)
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            _textWithoutSecureBullets = finalText
            super.text = _formatedSecureTextEntry ? finalSecureText : finalText
        }
        
        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if text.characters.count > maxLength {
                super.text = text.substring(to: text.index(text.startIndex, offsetBy: maxLength))
                _textWithoutSecureBullets = _textWithoutSecureBullets.substring(to: _textWithoutSecureBullets.characters.index(_textWithoutSecureBullets.startIndex, offsetBy: maxLength))
            }
        }
    }
}


// Helpers

fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


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

public enum TextFieldFormatting {
    case uuid
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
    public func setFormatting(_ formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
    }
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var replacementChar: Character = "*"
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var secureTextReplacementChar: Character = "\u{25cf}"
    
    /**
     True if input number is hexadecimal eg. UUID
     */
    public var isHexadecimal: Bool {
        return formatting == .uuid
    }
    
    /**
     Max length of input string. You don't have to set this if you set formattingPattern.
     If 0 -> no limit.
     */
    public var maxLength = 0
    
    /**
     Type of predefined text formatting. (You don't have to set this. It's more a future feature)
     */
    public var formatting : TextFieldFormatting = .noFormatting {
        didSet {
            switch formatting {
                
            case .socialSecurityNumber:
                self.formattingPattern = "***-**–****"
                self.replacementChar = "*"
                
            case .phoneNumber:
                self.formattingPattern = "***-***–****"
                self.replacementChar = "*"
                
            case .uuid:
                self.formattingPattern = "********-****-****-****-************"
                self.replacementChar = "*"
                
            default:
                self.maxLength = 0
            }
        }
    }
    
    /**
     String with formatting pattern for the text field.
     */
    public var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.count
            self.formatting = .custom
        }
    }
    
    /**
     Provides secure text entry but KEEPS formatting. All digits are replaced with the bullet character \u{25cf} .
     */
    public var formatedSecureTextEntry: Bool {
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
    public var finalStringWithoutFormatting : String {
        return _textWithoutSecureBullets.keepOnlyDigits(isHexadecimal: isHexadecimal)
    }
    
    // MARK: - INTERNAL
    fileprivate var _formatedSecureTextEntry = false
    
    // if secureTextEntry is false, this value is similar to self.text
    // if secureTextEntry is true, you can find final formatted text without bullets here
    fileprivate var _textWithoutSecureBullets = ""
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(TextFieldPatternFormat.textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: self)
    }
    
    @objc public func textDidChange() {
        var superText: String { return super.text ?? "" }
        
        let currentTextForFormatting: String
        
        if superText.count > _textWithoutSecureBullets.count {
            currentTextForFormatting = _textWithoutSecureBullets + superText[superText.index(superText.startIndex, offsetBy: _textWithoutSecureBullets.count)...]
        } else if superText.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            let index = _textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: superText.count)
            currentTextForFormatting = String(_textWithoutSecureBullets[..<index])
        }
        
        if formatting != .noFormatting && currentTextForFormatting.count > 0 && formattingPattern.count > 0 {
            let tempString = currentTextForFormatting.keepOnlyDigits(isHexadecimal: isHexadecimal)
            
            var finalText = ""
            var finalSecureText = ""
            
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                
                if formattingPattern[formattingPatternRange] != String(replacementChar) {
                    finalText = finalText + formattingPattern[formattingPatternRange]
                    finalSecureText = finalSecureText + formattingPattern[formattingPatternRange]
                    
                } else if tempString.count > 0 {
                    
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                    
                    finalText = finalText + tempString[pureStringRange]
                    
                    // we want the last number to be visible
                    if tempString.index(tempIndex, offsetBy: 1) == tempString.endIndex {
                        finalSecureText = finalSecureText + tempString[pureStringRange]
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
            
            let newText = _formatedSecureTextEntry ? finalSecureText : finalText
            if newText != superText {
                super.text = _formatedSecureTextEntry ? finalSecureText : finalText
            }
        }
        
        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if superText.count > maxLength {
                super.text = String(_textWithoutSecureBullets[..<superText.index(superText.startIndex, offsetBy: maxLength)])
                
                let index = _textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: maxLength)
                _textWithoutSecureBullets = String(_textWithoutSecureBullets[..<index])
            }
        }
    }
}

extension String {
    func keepOnlyDigits(isHexadecimal: Bool) -> String {
        let ucString = self.uppercased()
        let validCharacters = isHexadecimal ? "0123456789ABCDEF" : "0123456789"
        let characterSet: CharacterSet = CharacterSet(charactersIn: validCharacters)
        let stringArray = ucString.components(separatedBy: characterSet.inverted)
        let allNumbers = stringArray.joined(separator: "")
        return allNumbers
    }
}

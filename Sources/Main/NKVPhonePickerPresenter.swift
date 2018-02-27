//
//  NKVPhonePickerPresenter.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 27.02.18.
//  Copyright © 2018 nik.kov. All rights reserved.
//

class NKVPhonePickerPresenter {
    
    public func setCountry(source: NKVSource) {
        setFlag(source: source)
        setCode(source: source)
    }
    
    /// Method for set code in textField with Country entity.
    public func setCode(source: NKVSource) {
        var pe: String
        
        switch source {
        case .country(let country):
            pe = country.phoneExtension
        case .code:
            pe = PhoneExtension(source: source)?.phoneExtension ?? "?"
        case .phoneExtension(let phoneExtension):
            pe = phoneExtension.phoneExtension
    }
        
        textField.text = ""
        textField.text = "\(pe)"
    }
        
    /// Method for set flag with countryCode.
    public func setFlag(source: NKVSource) {
        textField.flagView.setFlag(with: source)
    }
    
    /// Use this method to enable phone formatting for country.
    /// It would take a custom pattern for the country code if it exists in customPhoneFormats var
    public func enablePhoneFormat(`for` country: Country) {
        if let customFormats = textField.customPhoneFormats {
            for format in customFormats {
                if country.countryCode.uppercased() == format.key {
                    textField.setFormatting(format.value, replacementChar: "#")
                    return
                }
            }
        }
        self.textField.setFormatting(country.formatPattern, replacementChar: "#")
    }
            
    
        
        
        
    // MARK: - Initialization
    
    internal weak var textField: NKVPhonePickerTextField!

    init(textField: NKVPhonePickerTextField) {
        self.textField = textField
    }
}

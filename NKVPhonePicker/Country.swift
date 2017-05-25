//
//  Country.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public class Country: NSObject {
    /// Ex: "RU"
    public var countryCode: String
    /// Ex: "+7"
    public var phoneExtension: String
    @objc public var name: String {
        return NKVLocalizationHelper.countryName(by: countryCode) ?? ""
    }

    public init(countryCode: String, phoneExtension: String) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
    }
    
    /// Returns a Country entity of the current iphone's localization region code
    /// or empty country if it not exist.
    public static var currentCountry: Country {
        guard let currentCountryCode = NKVLocalizationHelper.currentCode else {
            return Country.empty
        }
        return Countries.country(by: currentCountryCode)
    }
    
    /// Returnes an empty country entity for test or other purposes.
    public static var empty: Country {
        return Country(countryCode: "", phoneExtension: "")
    }
    
    /// Making entities comparable
    static public func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
}

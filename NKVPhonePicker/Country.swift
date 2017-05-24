//
//  Country.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public class Country: NSObject {
    public var countryCode: String
    public var phoneExtension: String
    @objc public var name: String {
        return (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) ?? ""
    }

    public init(countryCode: String, phoneExtension: String) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
    }
    
    /// Returns 
    public static var currentCountry: Country {
        return Countries.country(by: NKVLocalizationHelper.currentCode)
    }
    
    /// Returnes a country if there are not such a country in our array, or you just need for test purposes.
    public static var emptyCountry: Country {
        return Country(countryCode: "", phoneExtension: "")
    }
    
    /// Making entities comparable
    static public func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
}

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
    public var isMain: Bool
    @objc public var name: String {
        return (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) ?? ""
    }
    
    /// - Returns: A country if there are not such a country in our array, or you just need for test purposes.
    public static var emptyCountry: Country { return Country(countryCode: "", phoneExtension: "", isMain: true) }
    
    public static var currentCountry: Country {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return Countries.countryFrom(countryCode: countryCode)
        }
        return Country.emptyCountry
    }
    
    public init(countryCode: String, phoneExtension: String, isMain: Bool) {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.isMain = isMain
    }
    
 
    
    /// Making entities comparable
    static public func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
}

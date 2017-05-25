//
//  Countries.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public class Countries {
    /// Returns a country by a phone extension.
    ///
    /// - Parameter phoneExtension: For example: "+241"
    public class func countryFrom(phoneExtension: String) -> Country {
        let phoneExtension = (phoneExtension as NSString).replacingOccurrences(of: "+", with: "")
        for country in NKVSourcesHelper.countries {
            if phoneExtension == country.phoneExtension {
                return country
            }
        }
        return Country.empty
    }
    
    /// Returns a country by a country code.
    ///
    /// - Parameter countryCode: For example: "FR"
    public class func country(by countryCode: String) -> Country {
        for country in NKVSourcesHelper.countries {
            if countryCode.lowercased() == country.countryCode.lowercased() {
                return country
            }
        }
        return Country.empty
    }
    
    /// Returns a countries array from the country codes.
    ///
    /// - Parameter countryCodes: For example: ["FR", "EN"]
    public class func countries(by countryCodes: [String]) -> [Country] {
        return countryCodes.map { code in
            Countries.country(by: code)
        }
    }
}

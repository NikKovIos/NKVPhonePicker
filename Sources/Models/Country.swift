//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
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
    /// Ex: "### ## ######"
    public var formatPattern: String

    public init(countryCode: String, phoneExtension: String, formatPattern: String = "###################") {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.formatPattern = formatPattern
    }
    
    /// Returns a Country entity of the current iphone's localization region code
    /// or empty country if it not exist.
    public static var currentCountry: Country {
        guard let currentCountryCode = NKVLocalizationHelper.currentCode else {
            return Country.empty
        }
        return Country.countryBy(countryCode: currentCountryCode)
    }
    
    /// Making entities comparable
    static public func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
    
    // MARK: - Class methods   
    
    /// Returnes an empty country entity for test or other purposes. 
    /// "+" code returns a flag with question mark.
    public static var empty: Country {
        return Country(countryCode: "?", phoneExtension: "")
    }
    
    /// Returns a country by a phone extension.
    ///
    /// - Parameter phoneExtension: For example: "+241"
    public class func countryBy(phoneExtension: String) -> Country {
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
    public class func countryBy(countryCode: String) -> Country {
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
    public class func countriesBy(countryCodes: [String]) -> [Country] {
        return countryCodes.map { code in
            Country.countryBy(countryCode: code)
        }
    }
}

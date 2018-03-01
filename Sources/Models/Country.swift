//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import Foundation
import UIKit

open class Country: NSObject {
    
    // MARK: - Properties
    
    /// Ex: "RU"
    @objc public var countryCode: String
    /// Ex: "7"
    @objc public var phoneExtension: String
    /// Ex: "Russia"
    @objc public var name: String {
        return NKVLocalizationHelper.countryName(by: countryCode) ?? ""
    }
    /// Ex: "### ## ######"
    @objc public var formatPattern: String
    /// A flag image for this country. May be nil.
    public var flag: UIImage? {
        return NKVSourcesHelper.flag(for: NKVSource(country: self))
    }
    
    // MARK: - Initialization

    public init(countryCode: String,
                phoneExtension: String,
                formatPattern: String = "###################") {
        self.countryCode = countryCode
        self.phoneExtension = phoneExtension
        self.formatPattern = formatPattern
    }
    
    // MARK: - Country entities

    /// A Country entity of the current iphone's localization region code
    /// or nil if it not exist.
    public static var currentCountry: Country? {
        guard let currentCountryCode = NKVLocalizationHelper.currentCode else {
            return nil
        }
        return Country.country(for: NKVSource(countryCode: currentCountryCode))
    }
    
    /// An empty country entity for test or other purposes.
    /// "?" country code returns a flag with question mark.
    public static var empty: Country {
        return Country(countryCode: "?", phoneExtension: "")
    }
    
    // MARK: - Methods
    
    /// A main method for fetching a country
    ///
    /// - Parameter source: Any of the source, look **NKVSourceType**
    /// - Returns: A Country entity or nil if there is no exist for the source
    public class func country(`for` source: NKVSource) -> Country? {
        switch source {
        case .country(let country):
            return country
        case .code(let code):
            for country in NKVSourcesHelper.countries {
                if code.code.lowercased() == country.countryCode.lowercased() {
                    return country
                }
            }
        case .phoneExtension(let phoneExtension):
            let phoneExtension = phoneExtension.phoneExtension.cutPluses
            for country in NKVSourcesHelper.countries {
                if phoneExtension == country.phoneExtension {
                    return country
                }
            }
        }
        
        return nil
    }
    
    /// Returns a countries array from the country codes.
    ///
    /// - Parameter countryCodes: For example: ["FR", "EN"]
    public class func countriesBy(countryCodes: [String]) -> [Country] {
        return countryCodes.map { code in
            if let country = Country.country(for: NKVSource(countryCode: code)) {
                return country
            } else {
                print("⚠️ Country >>> Can't find a country for country code: \(code).\r Replacing it with dummy country. Please check your country ID or update a country database.")
                return Country.empty
            }
        }
    }
}

// MARK: - Equitable
extension Country {
    /// Making entities comparable
    static public func ==(lhs: Country, rhs: Country) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }
}

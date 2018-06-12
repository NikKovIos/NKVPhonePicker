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
            
            var matchingCountries = [Country]()
            
            let phoneExtension = phoneExtension.phoneExtension.cutPluses
            for country in NKVSourcesHelper.countries {
                if phoneExtension == country.phoneExtension {
                    matchingCountries.append(country)
                }
            }
            
            // If phone extension does not match any specific country, see if prefix of the extension is a match so we can pinpoint the country by local area code
            if matchingCountries.count == 0 {
                for country in NKVSourcesHelper.countries {
                    var tempPhoneExtension = phoneExtension
                    while tempPhoneExtension.count > 0 {
                        if tempPhoneExtension == country.phoneExtension {
                            matchingCountries.append(country)
                            break
                        } else {
                            tempPhoneExtension.remove(at: tempPhoneExtension.index(before: tempPhoneExtension.endIndex))
                        }
                    }
                }
            }

            // We have multiple countries for same phone extension. We decide which one to pick here.
            if matchingCountries.count > 0 {
                let matchingPhoneExtension = matchingCountries.first!.phoneExtension
                
                if phoneExtension.count > 1 {
                    // Deciding which country to pick based on local area code.
                    do {
                        if let file = Bundle(for: NKVPhonePickerTextField.self).url(forResource: "Countries.bundle/Data/localAreaCodes", withExtension: "json") {
                            
                            let data = try Data(contentsOf: file)
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            if let array = json  as? [String : [AnyObject]] {
                                if array.index(forKey: matchingPhoneExtension) != nil {
                                    // Found countries with given phone extension.
                                    for country in array[array.index(forKey: matchingPhoneExtension)!].value {
                                        if let areaCodes = country["localAreaCodes"] as? [String] {
                                            if phoneExtension.hasPrefix(matchingPhoneExtension) {
                                                var localAreaCode = String(phoneExtension.dropFirst(matchingPhoneExtension.count))
                                                localAreaCode = String(localAreaCode.prefix(areaCodes.first!.count))
                                                if areaCodes.contains(localAreaCode) {
                                                    // Found a specific country with given phone extension and local area code.
                                                    if let currentCountry = country["countryCode"] as? String {
                                                        return Country.country(for: NKVSource(countryCode: currentCountry))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            print("NKVPhonePickerTextField >>> Can't find a bundle for the local area codes")
                        }
                    } catch {
                        print("NKVPhonePickerTextField >>> \(error.localizedDescription)")
                    }
                }
                
                // Deciding which country to pick based on country priority.
                if let countryPriorities = NKVPhonePickerTextField.samePhoneExtensionCountryPriorities {
                    if let prioritizedCountry = countryPriorities[matchingPhoneExtension] {
                        return Country.country(for: NKVSource(countryCode: prioritizedCountry))
                    }
                }
                
                return matchingCountries.first
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

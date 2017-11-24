//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

struct NKVSourcesHelper {
    /// Returns the flag image or nil, if there are not such image for this code.
    public static func getFlagImage(by code: String) -> UIImage? {
        let flagImage = UIImage(named: "Countries.bundle/Images/\(code.uppercased())", in: Bundle(for: NKVPhonePickerTextField.self), compatibleWith: nil)
        
        return flagImage
    }
    
    /// Checks if the flag exists for this countryCode
    ///
    /// - Parameter countryCode: code of the country. Ex: "EN"
    /// - Returns: Bool value. True if exists.
    public static func isFlagExistsFor(countryCode: String) -> Bool {
        return (self.getFlagImage(by: countryCode) != nil)
    }
    
    /// Checks if the flag exists
    ///
    /// - Parameter countryCode: code of the country. Ex: "EN"
    /// - Returns: Cortege. If exists it returns assigned country, if not - empty dummy country.
    public static func isFlagExistsWith(countryCode: String) -> (exists: Bool, country: Country) {
        let countryWithString = Country.countryBy(countryCode: countryCode)
        if countryWithString == Country.empty {
            return (false, countryWithString)
        }
        return ((self.getFlagImage(by: countryWithString.countryCode) != nil), countryWithString)
    }
    
    public private(set) static var countries: [Country] = {
        var countries: [Country] = []
        
        do {
            if let file = Bundle(for: NKVPhonePickerTextField.self).url(forResource: "Countries.bundle/Data/countryCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let array = json as? Array<[String: String]> {
                    for object in array {
                        guard let code = object["code"],
                            let phoneExtension = object["dial_code"],
                            let formatPattern = object["format"] else {
                                fatalError("Must be valid json.")
                        }
                        countries.append(Country(countryCode: code,
                                                 phoneExtension: phoneExtension,
                                                 formatPattern: formatPattern))
                    }
                }
            } else {
                print("NKVPhonePickerTextField can't find a bundle for the countries")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return countries
    }()
}

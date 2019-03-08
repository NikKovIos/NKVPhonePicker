//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import UIKit

struct NKVSourcesHelper {
    
    /// Gives the flag image, if it exists in bundle.
    ///
    /// - Parameter source: Any of the source, look **NKVSourceType**
    /// - Returns: The flag image or nil, if there are not such image for this country code.
    public static func flag(`for` source: NKVSource) -> UIImage? {
        var countryCode: String = ""
        
        switch source {
        case .country(let country):
            countryCode = country.countryCode
        case .code(let code):
            countryCode = code.code
        case .phoneExtension:
            guard let country = Country.country(for: source) else {
                return nil
            }
            countryCode = country.countryCode
        }
        
        let imageName = "Countries.bundle/Images/\(countryCode.uppercased())"
        let flagImage = UIImage(named: imageName,
                           in: Bundle(for: NKVPhonePickerTextField.self),
                           compatibleWith: nil)
        return flagImage
    }
    
    /// - Parameter code: Country code like 'ru' or 'RU' independed of the letter case.
    /// - Returns: True of false dependenly if the image of the flag exists in the bundle.
    public static func isFlagExists(`for` source: NKVSource) -> Bool {
        return self.flag(for: source) != nil
    }
    
    /// The array of all countries in the bundle
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
                print("NKVPhonePickerTextField >>> Can't find a bundle for the countries")
            }
        } catch {
            print("NKVPhonePickerTextField >>> \(error.localizedDescription)")
        }
        
        return countries
    }()
}

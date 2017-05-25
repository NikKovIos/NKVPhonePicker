//
//  NKVSourcesHelper.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 24.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

import UIKit

struct NKVSourcesHelper {
    /// Returns the flag image or nil, if there are not such image for this code.
    public static func getFlagImage(by code: String) -> UIImage? {
        let flagImage = UIImage(named: "Countries.bundle/Images/\(code.uppercased())", in: Bundle(for: NKVPhonePickerTextField.self), compatibleWith: nil)
        
        return flagImage
    }
    
    public static func isFlagExistsFor(countryCode: String) -> Bool {
        return (self.getFlagImage(by: countryCode) != nil)
    }
    
    public static func isFlagExistsWith(phoneExtension: String) -> Bool {
        let countryWithString = Country.countryBy(phoneExtension: phoneExtension)
        if countryWithString == Country.empty { return false }
        return (self.getFlagImage(by: countryWithString.countryCode) != nil)
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
                            let phoneExtension = object["dial_code"] else {
                            fatalError("Must be valid json.")
                        }
                        countries.append(Country(countryCode: code,
                                                 phoneExtension: phoneExtension))
                    }
                }
            } else {
                print("No such a file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return countries
    }()
}

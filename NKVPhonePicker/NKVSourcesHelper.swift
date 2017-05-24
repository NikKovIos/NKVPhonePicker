//
//  NKVSourcesHelper.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 24.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

import UIKit

struct NKVSourcesHelper {
    public static func getFlagImage(by code: String) -> UIImage {
        let flagImage = UIImage(named: "Countries.bundle/Images/\(code.uppercased())", in: Bundle(for: NKVPhonePickerTextField.self), compatibleWith: nil)
        
        return flagImage ?? UIImage()
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

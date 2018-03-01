//
//  CountryCode.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 27.02.18.
//  Copyright © 2018 nik.kov. All rights reserved.
//

public struct CountryCode {
    public var code: String
    
    public init?(_ source: NKVSource) {
        switch source {
        case .country(let country):
            self.code = country.countryCode
        case .code(let code):
            self.code = code.code
        case .phoneExtension:
            if let country = Country.country(for: source) {
                self.code = country.countryCode
            } else {
                return nil
            }
        }
    }
    
    public init(_ countryCode: String) {
        self.code = countryCode
    }
}

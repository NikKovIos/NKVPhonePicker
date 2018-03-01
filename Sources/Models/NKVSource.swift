//
//  NKVSource.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 01.03.18.
//  Copyright © 2018 nik.kov. All rights reserved.
//

public enum NKVSource {
    case country(Country)
    case code(CountryCode)
    case phoneExtension(PhoneExtension)
    
    public init(country: Country) {
        self = .country(country)
    }
    
    public init(countryCode: String) {
        self = .code(CountryCode(countryCode))
    }
    
    public init(phoneExtension: String) {
        self = .phoneExtension(PhoneExtension(phoneExtension))
    }
}

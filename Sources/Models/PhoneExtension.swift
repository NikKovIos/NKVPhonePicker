//
//  PhoneExtension.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 27.02.18.
//  Copyright © 2018 nik.kov. All rights reserved.
//

public struct PhoneExtension {
    var phoneExtension: String
    
    init?(source: NKVSource) {
        switch source {
        case .country(let country):
            self.phoneExtension = country.phoneExtension
        case .code:
            if let country = Country.country(for: source) {
                self.phoneExtension = country.phoneExtension
            } else {
                return nil
            }
        case .phoneExtension(let phoneExtension):
            self.phoneExtension = phoneExtension.phoneExtension
        }
    }
    
    init(_ phoneExtension: String) {
        self.phoneExtension = phoneExtension
    }
}

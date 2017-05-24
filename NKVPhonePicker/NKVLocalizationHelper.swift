//
//  NKVLocalizationHelper.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 24.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

import Foundation

struct NKVLocalizationHelper {
    /// Returns the code of the country (region) of the current localization.
    ///
    /// Ex: For Russian phone language it would be "RU".
    ///
    /// If region code didn't found - it would be "JM" by default.
    static var currentCode: String {
        let currentLocale = Locale.current
        let regionCode = currentLocale.regionCode?.uppercased()
        print(regionCode ?? "NO CODE AVAILABLE")
        return regionCode ?? "JM"
    }
}

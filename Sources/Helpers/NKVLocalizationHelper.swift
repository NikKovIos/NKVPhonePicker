//
// Be happy and free :)
//
// Nik Kov
// nik-kov.com
//

import Foundation

struct NKVLocalizationHelper {
    /// Returns the code of the country (region) of the current localization.
    ///
    /// Ex: For Russian phone language it would be "RU".
    public static var currentCode: String? {
        let currentLocale = Locale.current
        let regionCode = currentLocale.regionCode?.uppercased()
        return regionCode
    }
    
    /// Returns a localized country name by a country code of the current locale.
    public static func countryName(by countryCode: String) -> String? {
        return (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode)
    }
}

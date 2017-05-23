//
//  Countries.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import Foundation

public class Countries {
    /// Returns a country by a phone extension.
    ///
    /// - Parameter phoneExtension: For example: "+241"
    public class func countryFrom(phoneExtension: String) -> Country {
        let phoneExtension = (phoneExtension as NSString).replacingOccurrences(of: "+", with: "")
        for country in countries {
            if country.isMain
                && phoneExtension == country.phoneExtension {
                return country
            }
        }
        return Country.emptyCountry
    }
    
    /// Returns a country by a country code.
    ///
    /// - Parameter countryCode: For example: "FR"
    public class func countryFrom(countryCode: String) -> Country {
        for country in countries {
            if countryCode.lowercased() == country.countryCode.lowercased() {
                return country
            }
        }
        return Country.emptyCountry
    }
    
    /// Returns a countries array from the country codes.
    ///
    /// - Parameter countryCodes: For example: ["FR", "EN"]
    public class func countriesFrom(countryCodes: [String]) -> [Country] {
        return countryCodes.map { code in
            Countries.countryFrom(countryCode: code)
        }
    }
    
    public private(set) static var countries: [Country] = {
        var countries: [Country] = []
        
        countries.append(Country(countryCode: "AF", phoneExtension: "93", isMain: true))
        countries.append(Country(countryCode: "AL", phoneExtension: "355", isMain: true))
        countries.append(Country(countryCode: "DZ", phoneExtension: "213", isMain: true))
        countries.append(Country(countryCode: "AS", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "AD", phoneExtension: "376", isMain: true))
        countries.append(Country(countryCode: "AO", phoneExtension: "244", isMain: true))
        countries.append(Country(countryCode: "AI", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "AQ", phoneExtension: "672", isMain: true))
        countries.append(Country(countryCode: "AG", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "AR", phoneExtension: "54", isMain: true))
        countries.append(Country(countryCode: "AM", phoneExtension: "374", isMain: true))
        countries.append(Country(countryCode: "AW", phoneExtension: "297", isMain: true))
        countries.append(Country(countryCode: "AU", phoneExtension: "61", isMain: true))
        countries.append(Country(countryCode: "AT", phoneExtension: "43", isMain: true))
        countries.append(Country(countryCode: "AZ", phoneExtension: "994", isMain: true))
        
        
        countries.append(Country(countryCode: "BS", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "BH", phoneExtension: "973", isMain: true))
        countries.append(Country(countryCode: "BD", phoneExtension: "880", isMain: true))
        countries.append(Country(countryCode: "BB", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "BY", phoneExtension: "375", isMain: true))
        countries.append(Country(countryCode: "BE", phoneExtension: "32", isMain: true))
        countries.append(Country(countryCode: "BZ", phoneExtension: "501", isMain: true))
        countries.append(Country(countryCode: "BJ", phoneExtension: "229", isMain: true))
        countries.append(Country(countryCode: "BM", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "BT", phoneExtension: "975", isMain: true))
        countries.append(Country(countryCode: "BO", phoneExtension: "591", isMain: true))
        countries.append(Country(countryCode: "BA", phoneExtension: "387", isMain: true))
        countries.append(Country(countryCode: "BW", phoneExtension: "267", isMain: true))
        countries.append(Country(countryCode: "BR", phoneExtension: "55", isMain: true))
        countries.append(Country(countryCode: "IO", phoneExtension: "246", isMain: true))
        countries.append(Country(countryCode: "VG", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "BN", phoneExtension: "673", isMain: true))
        countries.append(Country(countryCode: "BG", phoneExtension: "359", isMain: true))
        countries.append(Country(countryCode: "BF", phoneExtension: "226", isMain: true))
        countries.append(Country(countryCode: "BI", phoneExtension: "257", isMain: true))
        countries.append(Country(countryCode: "KH", phoneExtension: "855", isMain: true))
        countries.append(Country(countryCode: "CM", phoneExtension: "237", isMain: true))
        countries.append(Country(countryCode: "CA", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "CV", phoneExtension: "238", isMain: true))
        
        countries.append(Country(countryCode: "KY", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "CF", phoneExtension: "236", isMain: true))
        countries.append(Country(countryCode: "TD", phoneExtension: "235", isMain: true))
        countries.append(Country(countryCode: "CL", phoneExtension: "56", isMain: true))
        countries.append(Country(countryCode: "CN", phoneExtension: "86", isMain: true))
        countries.append(Country(countryCode: "CX", phoneExtension: "61", isMain: false))
        countries.append(Country(countryCode: "CC", phoneExtension: "61", isMain: false))
        countries.append(Country(countryCode: "CO", phoneExtension: "57", isMain: true))
        countries.append(Country(countryCode: "KM", phoneExtension: "269", isMain: true))
        countries.append(Country(countryCode: "CK", phoneExtension: "682", isMain: true))
        countries.append(Country(countryCode: "CR", phoneExtension: "506", isMain: true))
        countries.append(Country(countryCode: "HR", phoneExtension: "385", isMain: true))
        countries.append(Country(countryCode: "CU", phoneExtension: "53", isMain: true))
        countries.append(Country(countryCode: "CW", phoneExtension: "599", isMain: true))
        countries.append(Country(countryCode: "CY", phoneExtension: "357", isMain: true))
        countries.append(Country(countryCode: "CZ", phoneExtension: "420", isMain: true))
        countries.append(Country(countryCode: "CD", phoneExtension: "243", isMain: true))
        
        countries.append(Country(countryCode: "DK", phoneExtension: "45", isMain: true))
        countries.append(Country(countryCode: "DJ", phoneExtension: "253", isMain: true))
        countries.append(Country(countryCode: "DM", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "DO", phoneExtension: "1", isMain: false))
        
        countries.append(Country(countryCode: "TL", phoneExtension: "670", isMain: true))
        countries.append(Country(countryCode: "EC", phoneExtension: "593", isMain: true))
        countries.append(Country(countryCode: "EG", phoneExtension: "20", isMain: true))
        countries.append(Country(countryCode: "SV", phoneExtension: "503", isMain: true))
        countries.append(Country(countryCode: "GQ", phoneExtension: "240", isMain: true))
        countries.append(Country(countryCode: "ER", phoneExtension: "291", isMain: true))
        countries.append(Country(countryCode: "EE", phoneExtension: "372", isMain: true))
        countries.append(Country(countryCode: "ET", phoneExtension: "251", isMain: true))
        
        countries.append(Country(countryCode: "FK", phoneExtension: "500", isMain: true))
        countries.append(Country(countryCode: "FO", phoneExtension: "298", isMain: true))
        countries.append(Country(countryCode: "FJ", phoneExtension: "679", isMain: true))
        countries.append(Country(countryCode: "FI", phoneExtension: "358", isMain: true))
        countries.append(Country(countryCode: "FR", phoneExtension: "33", isMain: true))
        countries.append(Country(countryCode: "PF", phoneExtension: "689", isMain: true))
        
        countries.append(Country(countryCode: "GA", phoneExtension: "241", isMain: true))
        countries.append(Country(countryCode: "GM", phoneExtension: "220", isMain: true))
        countries.append(Country(countryCode: "GE", phoneExtension: "995", isMain: true))
        countries.append(Country(countryCode: "DE", phoneExtension: "49", isMain: true))
        countries.append(Country(countryCode: "GH", phoneExtension: "233", isMain: true))
        countries.append(Country(countryCode: "GI", phoneExtension: "350", isMain: true))
        countries.append(Country(countryCode: "GR", phoneExtension: "30", isMain: true))
        countries.append(Country(countryCode: "GL", phoneExtension: "299", isMain: true))
        countries.append(Country(countryCode: "GD", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "GU", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "GT", phoneExtension: "502", isMain: true))
        countries.append(Country(countryCode: "GG", phoneExtension: "44", isMain: false))
        countries.append(Country(countryCode: "GN", phoneExtension: "224", isMain: true))
        countries.append(Country(countryCode: "GW", phoneExtension: "245", isMain: true))
        countries.append(Country(countryCode: "GY", phoneExtension: "592", isMain: true))
        
        countries.append(Country(countryCode: "HT", phoneExtension: "509", isMain: true))
        countries.append(Country(countryCode: "HN", phoneExtension: "504", isMain: true))
        countries.append(Country(countryCode: "HK", phoneExtension: "852", isMain: true))
        countries.append(Country(countryCode: "HU", phoneExtension: "36", isMain: true))
        
        countries.append(Country(countryCode: "IS", phoneExtension: "354", isMain: true))
        countries.append(Country(countryCode: "IN", phoneExtension: "91", isMain: true))
        countries.append(Country(countryCode: "ID", phoneExtension: "62", isMain: true))
        countries.append(Country(countryCode: "IR", phoneExtension: "98", isMain: true))
        countries.append(Country(countryCode: "IQ", phoneExtension: "964", isMain: true))
        countries.append(Country(countryCode: "IE", phoneExtension: "353", isMain: true))
        countries.append(Country(countryCode: "IM", phoneExtension: "44", isMain: false))
        countries.append(Country(countryCode: "IL", phoneExtension: "972", isMain: true))
        countries.append(Country(countryCode: "IT", phoneExtension: "39", isMain: true))
        countries.append(Country(countryCode: "CI", phoneExtension: "225", isMain: true))
        
        countries.append(Country(countryCode: "JM", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "JP", phoneExtension: "81", isMain: true))
        countries.append(Country(countryCode: "JE", phoneExtension: "44", isMain: false))
        countries.append(Country(countryCode: "JO", phoneExtension: "962", isMain: true))
        
        countries.append(Country(countryCode: "KZ", phoneExtension: "7", isMain: false))
        countries.append(Country(countryCode: "KE", phoneExtension: "254", isMain: true))
        countries.append(Country(countryCode: "KI", phoneExtension: "686", isMain: true))
        countries.append(Country(countryCode: "XK", phoneExtension: "383", isMain: true))
        countries.append(Country(countryCode: "KW", phoneExtension: "965", isMain: true))
        countries.append(Country(countryCode: "KG", phoneExtension: "996", isMain: true))
        
        countries.append(Country(countryCode: "LA", phoneExtension: "856", isMain: true))
        countries.append(Country(countryCode: "LV", phoneExtension: "371", isMain: true))
        countries.append(Country(countryCode: "LB", phoneExtension: "961", isMain: true))
        countries.append(Country(countryCode: "LS", phoneExtension: "266", isMain: true))
        countries.append(Country(countryCode: "LR", phoneExtension: "231", isMain: true))
        countries.append(Country(countryCode: "LY", phoneExtension: "218", isMain: true))
        countries.append(Country(countryCode: "LI", phoneExtension: "423", isMain: true))
        countries.append(Country(countryCode: "LT", phoneExtension: "370", isMain: true))
        countries.append(Country(countryCode: "LU", phoneExtension: "352", isMain: true))
        
        countries.append(Country(countryCode: "MO", phoneExtension: "853", isMain: true))
        countries.append(Country(countryCode: "MK", phoneExtension: "389", isMain: true))
        countries.append(Country(countryCode: "MG", phoneExtension: "261", isMain: true))
        countries.append(Country(countryCode: "MW", phoneExtension: "265", isMain: true))
        countries.append(Country(countryCode: "MY", phoneExtension: "60", isMain: true))
        countries.append(Country(countryCode: "MV", phoneExtension: "960", isMain: true))
        countries.append(Country(countryCode: "ML", phoneExtension: "223", isMain: true))
        countries.append(Country(countryCode: "MT", phoneExtension: "356", isMain: true))
        countries.append(Country(countryCode: "MH", phoneExtension: "692", isMain: true))
        countries.append(Country(countryCode: "MR", phoneExtension: "222", isMain: true))
        countries.append(Country(countryCode: "MU", phoneExtension: "230", isMain: true))
        countries.append(Country(countryCode: "YT", phoneExtension: "262", isMain: true))
        countries.append(Country(countryCode: "MX", phoneExtension: "52", isMain: true))
        countries.append(Country(countryCode: "FM", phoneExtension: "691", isMain: true))
        countries.append(Country(countryCode: "MD", phoneExtension: "373", isMain: true))
        countries.append(Country(countryCode: "MC", phoneExtension: "377", isMain: true))
        countries.append(Country(countryCode: "MN", phoneExtension: "976", isMain: true))
        countries.append(Country(countryCode: "ME", phoneExtension: "382", isMain: true))
        countries.append(Country(countryCode: "MS", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "MA", phoneExtension: "212", isMain: true))
        countries.append(Country(countryCode: "MZ", phoneExtension: "258", isMain: true))
        countries.append(Country(countryCode: "MM", phoneExtension: "95", isMain: true))
        
        countries.append(Country(countryCode: "NA", phoneExtension: "264", isMain: true))
        countries.append(Country(countryCode: "NR", phoneExtension: "674", isMain: true))
        countries.append(Country(countryCode: "NP", phoneExtension: "977", isMain: true))
        countries.append(Country(countryCode: "NL", phoneExtension: "31", isMain: true))
        countries.append(Country(countryCode: "AN", phoneExtension: "599", isMain: true))
        countries.append(Country(countryCode: "NC", phoneExtension: "687", isMain: true))
        countries.append(Country(countryCode: "NZ", phoneExtension: "64", isMain: true))
        countries.append(Country(countryCode: "NI", phoneExtension: "505", isMain: true))
        countries.append(Country(countryCode: "NE", phoneExtension: "227", isMain: true))
        countries.append(Country(countryCode: "NG", phoneExtension: "234", isMain: true))
        countries.append(Country(countryCode: "NU", phoneExtension: "683", isMain: true))
        countries.append(Country(countryCode: "KP", phoneExtension: "850", isMain: true))
        countries.append(Country(countryCode: "MP", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "NO", phoneExtension: "47", isMain: true))
        
        countries.append(Country(countryCode: "OM", phoneExtension: "968", isMain: true))
        
        countries.append(Country(countryCode: "PK", phoneExtension: "92", isMain: true))
        countries.append(Country(countryCode: "PW", phoneExtension: "680", isMain: true))
        countries.append(Country(countryCode: "PS", phoneExtension: "970", isMain: true))
        countries.append(Country(countryCode: "PA", phoneExtension: "507", isMain: true))
        countries.append(Country(countryCode: "PG", phoneExtension: "675", isMain: true))
        countries.append(Country(countryCode: "PY", phoneExtension: "595", isMain: true))
        countries.append(Country(countryCode: "PE", phoneExtension: "51", isMain: true))
        countries.append(Country(countryCode: "PH", phoneExtension: "63", isMain: true))
        countries.append(Country(countryCode: "PN", phoneExtension: "64", isMain: false))
        countries.append(Country(countryCode: "PL", phoneExtension: "48", isMain: true))
        countries.append(Country(countryCode: "PT", phoneExtension: "351", isMain: true))
        countries.append(Country(countryCode: "PR", phoneExtension: "1", isMain: false))
        
        countries.append(Country(countryCode: "QA", phoneExtension: "974", isMain: true))
        
        countries.append(Country(countryCode: "CG", phoneExtension: "242", isMain: true))
        countries.append(Country(countryCode: "RE", phoneExtension: "262", isMain: false))
        countries.append(Country(countryCode: "RO", phoneExtension: "40", isMain: true))
        countries.append(Country(countryCode: "RU", phoneExtension: "7", isMain: true))
        countries.append(Country(countryCode: "RW", phoneExtension: "250", isMain: true))
        
        countries.append(Country(countryCode: "BL", phoneExtension: "590", isMain: true))
        countries.append(Country(countryCode: "SH", phoneExtension: "290", isMain: true))
        countries.append(Country(countryCode: "KN", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "LC", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "MF", phoneExtension: "590", isMain: false))
        countries.append(Country(countryCode: "PM", phoneExtension: "508", isMain: true))
        
        countries.append(Country(countryCode: "VC", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "WS", phoneExtension: "685", isMain: true))
        countries.append(Country(countryCode: "SM", phoneExtension: "378", isMain: true))
        countries.append(Country(countryCode: "ST", phoneExtension: "239", isMain: true))
        countries.append(Country(countryCode: "SA", phoneExtension: "966", isMain: true))
        countries.append(Country(countryCode: "SN", phoneExtension: "221", isMain: true))
        countries.append(Country(countryCode: "RS", phoneExtension: "381", isMain: true))
        countries.append(Country(countryCode: "SC", phoneExtension: "248", isMain: true))
        countries.append(Country(countryCode: "SL", phoneExtension: "232", isMain: true))
        countries.append(Country(countryCode: "SG", phoneExtension: "65", isMain: true))
        countries.append(Country(countryCode: "SX", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "SK", phoneExtension: "421", isMain: true))
        countries.append(Country(countryCode: "SI", phoneExtension: "386", isMain: true))
        countries.append(Country(countryCode: "SB", phoneExtension: "677", isMain: true))
        countries.append(Country(countryCode: "SO", phoneExtension: "252", isMain: true))
        countries.append(Country(countryCode: "ZA", phoneExtension: "27", isMain: true))
        countries.append(Country(countryCode: "KR", phoneExtension: "82", isMain: true))
        countries.append(Country(countryCode: "SS", phoneExtension: "211", isMain: true))
        countries.append(Country(countryCode: "ES", phoneExtension: "34", isMain: true))
        countries.append(Country(countryCode: "LK", phoneExtension: "94", isMain: true))
        countries.append(Country(countryCode: "SD", phoneExtension: "249", isMain: true))
        countries.append(Country(countryCode: "SR", phoneExtension: "597", isMain: true))
        countries.append(Country(countryCode: "SJ", phoneExtension: "47", isMain: true))
        countries.append(Country(countryCode: "SZ", phoneExtension: "268", isMain: true))
        countries.append(Country(countryCode: "SE", phoneExtension: "46", isMain: true))
        countries.append(Country(countryCode: "CH", phoneExtension: "41", isMain: true))
        countries.append(Country(countryCode: "SY", phoneExtension: "963", isMain: true))
        
        countries.append(Country(countryCode: "TW", phoneExtension: "886", isMain: true))
        countries.append(Country(countryCode: "TJ", phoneExtension: "992", isMain: true))
        countries.append(Country(countryCode: "TZ", phoneExtension: "255", isMain: true))
        countries.append(Country(countryCode: "TH", phoneExtension: "66", isMain: true))
        countries.append(Country(countryCode: "TG", phoneExtension: "228", isMain: true))
        countries.append(Country(countryCode: "TK", phoneExtension: "690", isMain: true))
        countries.append(Country(countryCode: "TO", phoneExtension: "676", isMain: true))
        countries.append(Country(countryCode: "TT", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "TN", phoneExtension: "216", isMain: true))
        countries.append(Country(countryCode: "TR", phoneExtension: "90", isMain: true))
        countries.append(Country(countryCode: "TM", phoneExtension: "993", isMain: true))
        countries.append(Country(countryCode: "TC", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "TV", phoneExtension: "688", isMain: true))
        
        countries.append(Country(countryCode: "VI", phoneExtension: "1", isMain: false))
        countries.append(Country(countryCode: "UG", phoneExtension: "256", isMain: true))
        countries.append(Country(countryCode: "UA", phoneExtension: "380", isMain: true))
        countries.append(Country(countryCode: "AE", phoneExtension: "971", isMain: true))
        countries.append(Country(countryCode: "GB", phoneExtension: "44", isMain: true))
        countries.append(Country(countryCode: "US", phoneExtension: "1", isMain: true))
        countries.append(Country(countryCode: "UY", phoneExtension: "598", isMain: true))
        countries.append(Country(countryCode: "UZ", phoneExtension: "998", isMain: true))
        
        countries.append(Country(countryCode: "VU", phoneExtension: "678", isMain: true))
        countries.append(Country(countryCode: "VA", phoneExtension: "379", isMain: true))
        countries.append(Country(countryCode: "VE", phoneExtension: "58", isMain: true))
        countries.append(Country(countryCode: "VN", phoneExtension: "84", isMain: true))
        
        countries.append(Country(countryCode: "WF", phoneExtension: "681", isMain: true))
        countries.append(Country(countryCode: "EH", phoneExtension: "212", isMain: true))
        
        countries.append(Country(countryCode: "YE", phoneExtension: "967", isMain: true))
        
        countries.append(Country(countryCode: "ZM", phoneExtension: "260", isMain: true))
        countries.append(Country(countryCode: "ZW", phoneExtension: "263", isMain: true))
        
        return countries
        }()
}

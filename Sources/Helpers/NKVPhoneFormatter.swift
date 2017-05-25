//
//  NKVFormatter.swift
//  NKVPhonePicker
//
//  Created by Nik Kov on 25.05.17.
//  Copyright © 2017 nik.kov. All rights reserved.
//

extension String {
    var cutSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var cutPluses: String {
        return self.replacingOccurrences(of: "+", with: "")
    }
}

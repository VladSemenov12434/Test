//
//  String + Extention.swift
//  Itunes_testTask_youTube
//
//  Created by MacBook Pro on 23/10/2023.
//

import Foundation

    extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
    }
        enum Regex: String {
            
            case name = "[a-zA-Z{<1,}"
            case email = "[a-zA-Z0-9_]+@[a-zA-Z]\\.[a-zA-Z]{2,} "
            case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
        }
        func isValid(validType: ValidTypes) -> Bool {
            let format = "SELF MATCHES %@"
            var regex = ""
            
            switch validType {
            case .name: regex = Regex.name.rawValue
            case .email: regex = Regex.email.rawValue
            case .password: regex = Regex.email.rawValue
                
            default:
                print("1")
            }
            
            return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

//
//  Date+Extensions.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 25/11/20.
//

import Foundation

extension Date {
    
    // Syntax candy for retrieving short, formatted strings from a date
    var shortDateTimeString: String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .short)
    }
    
    var shortDateString: String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    }
    
}

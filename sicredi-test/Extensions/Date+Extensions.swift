//
//  Date+Extensions.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 25/11/20.
//

import Foundation

extension Date {
    
    // Syntax candy for retrieving a short, formatted string from a date
    var formattedString: String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .short)
    }
    
}

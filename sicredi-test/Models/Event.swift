//
//  Event.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 22/11/20.
//

import Foundation

struct Event: Codable, Identifiable {
    var id: String = ""
    
    var date: Date = .distantPast
    var description: String = ""
    var image: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var price: Double = 0
    var title: String = ""
    
    var people: [Person] = []
}

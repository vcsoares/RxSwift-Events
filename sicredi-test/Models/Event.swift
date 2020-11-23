//
//  Event.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 22/11/20.
//

import Foundation

struct Event: Codable, Identifiable {
    
    var people: [Person]
    var date: Date
    var description: String
    var image: String
    var latitude: Double
    var longitude: Double
    var price: Double
    var title: String
    var id: String
    
}

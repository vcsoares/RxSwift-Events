//
//  EventDetailsViewModel.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import RxCocoa
import RxSwift

class EventDetailsViewModel {
    var event: Event
    
    init(with event: Event) {
        self.event = event
    }
}

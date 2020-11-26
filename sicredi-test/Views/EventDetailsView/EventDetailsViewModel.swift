//
//  EventDetailsViewModel.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import CoreLocation
import Contacts
import RxCocoa
import RxSwift

class EventDetailsViewModel {
    var event: Event
    var location: CLLocationCoordinate2D

    var address: Observable<String> {
        return addressRelay.asObservable().distinctUntilChanged()
    }
    
    private var addressRelay = BehaviorRelay<String>(value: "")
    
    init(with event: Event) {
        self.event = event
        self.location = CLLocationCoordinate2D(latitude: event.latitude, longitude: event.longitude)
        self.fetchEventLocation()
    }
    
    func fetchEventLocation() {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: event.latitude, longitude: event.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let placemark = placemarks?.first,
               let placemarkAddress = placemark.postalAddress {
                let address = "\(placemarkAddress.street)\n\(placemarkAddress.city) - \(placemarkAddress.state)"
                self.addressRelay.accept(address)
            }
        }
    }
}

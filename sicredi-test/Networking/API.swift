//
//  API.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import RxSwift
import RxCocoa

final class API {
    static let shared = API()
    
    enum Endpoints: String {
        case events = "/events"
        case checkin = "/checkin"
    }
    
    enum Error: Swift.Error {
        case invalidResponse(URLResponse?)
        case invalidJSON(Swift.Error)
    }
    
    private let baseURL = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api")!
    
    // MARK: - Methods
    
    /// fetchEvents()
    /// Fetches a list of all Events from the API endpoint.
    /// If a bad response is received, throws an invalidResponse error.
    /// If unable to parse JSON response, throws an invalidJSON error.
    /// - Returns: an Observable array of Event instances, that can be subscribed to.
    func fetchEvents() -> Observable<[Event]> {
        let request = URLRequest(url: baseURL.appendingPathComponent(Endpoints.events.rawValue))
        
        return URLSession.shared.rx.response(request: request)
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                guard (200...399).contains(response.statusCode) else {
                    throw Error.invalidResponse(response)
                }
                
                return data
            }
            .map { data -> [Event] in
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    let results = try decoder.decode([Event].self, from: data)
                    
                    return results
                } catch {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
    
    /// fetchEvent(with:)
    /// Fetches the Event that corresponds to the requested event id.
    /// If a bad response is received, throws an invalidResponse error.
    /// If unable to parse JSON response, throws an invalidJSON error.
    /// - Parameter id: a String representing the requested event's id.
    /// - Returns: an Observable Event, that can be subscribed to.
    func fetchEvent(with id: String) -> Observable<Event> {
        let request = URLRequest(
            url: baseURL
                .appendingPathComponent(Endpoints.events.rawValue)
                .appendingPathComponent(id)
        )
        
        return URLSession.shared.rx.response(request: request)
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                guard (200...399).contains(response.statusCode) else {
                    throw Error.invalidResponse(response)
                }
                
                return data
            }
            .map { data -> Event in
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    let results = try decoder.decode(Event.self, from: data)
                    
                    return results
                } catch {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
    
    /// checkin(user:, to:)
    /// Checks-in a user to the desired Event, by POSTing their contact information to the API endpoint.
    /// If a bad response is received, throws an invalidResponse error.
    /// If unable to parse JSON response, throws an invalidJSON error.
    /// - Parameters:
    ///   - user: a Person instance containing the user's data for checkin.
    ///   - event: the Event the user wants to checkin to.
    /// - Returns: an Observable Boolean that will be true if the checkin has succeeded, and false otherwise.
    func checkin(user: Person, to event: Event) -> Observable<Bool> {
        var request = URLRequest(url: baseURL.appendingPathComponent(Endpoints.checkin.rawValue))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: [
                "eventId": event.id,
                "name": user.name,
                "email": user.email
            ],
            options: []
        )
        
        return URLSession.shared.rx.response(request: request)
            .map { (response: HTTPURLResponse, data: Data) -> Data in
                guard (200...399).contains(response.statusCode) else {
                    throw Error.invalidResponse(response)
                }
                
                return data
            }
            .map { data -> Bool in
                do {
                    let decoder = JSONDecoder()
                    
                    let results = try decoder.decode([String : String].self, from: data)
                    
                    if let code = results["code"],
                       (200...399).contains(Int(code) ?? 0) {
                        return true
                    } else {
                        return false
                    }
                } catch {
                    throw Error.invalidJSON(error)
                }
            }
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
    
}

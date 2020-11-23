//
//  APITests.swift
//  sicredi-testTests
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import Quick
import Nimble
import RxSwift
@testable import sicredi_test

class APITests: QuickSpec {
    let disposeBag = DisposeBag()
    
    override func spec() {
        describe("API methods") {
            context("WHEN a list of Events is requested") {
                it("THEN an array of Event instances is eventually returned") {
                    var events: [sicredi_test.Event] = []
                    
                    API.shared.fetchEvents()
                        .subscribe(
                            onNext: { results in
                                events = results
                                print(events)
                            },
                            onError: { error in
                                fail("\(error)")
                            }
                        )
                        .disposed(by: self.disposeBag)
                    
                    expect(events).toEventuallyNot(beEmpty(), timeout: 5)
                }
            }
            
            context("WHEN information of a specific Event is requested") {
                it("THEN an instance of that Event is eventually returned") {
                    var event = sicredi_test.Event()
                    
                    API.shared.fetchEvent(with: "2")
                        .subscribe(
                            onNext: { result in
                                event = result
                                print(event)
                            },
                            onError: { error in
                                fail("\(error)")
                            }
                        )
                        .disposed(by: self.disposeBag)
                    
                    expect(event.id).toEventually(equal("2"), timeout: 5)
                }
            }
            
            context("WHEN information of a non-existant Event is requested") {
                it("THEN the method should fail gracefully") {
                    waitUntil(timeout: 5) { done in
                        API.shared.fetchEvent(with: "batata")
                            .subscribe(
                                onNext: { result in
                                    fail("No result expected!")
                                    done()
                                },
                                onError: { error in
                                    expect(error).to(beAKindOf(sicredi_test.API.Error.self))
                                    done()
                                }
                            )
                            .disposed(by: self.disposeBag)
                    }
                }
            }
            
            context("WHEN someone is interested in an Event") {
                let person = Person(name: "Teste", email: "a@b.com")
                
                it("THEN they should be able to checkin to it") {
                    waitUntil(timeout: 10) { done in
                        API.shared.fetchEvent(with: "2")
                            .subscribe(
                                onNext: { result in
                                    print(result)
                                    API.shared.checkin(user: person, to: result)
                                        .subscribe(
                                            onNext: { hasSucceded in
                                                expect(hasSucceded).to(beTrue())
                                                done()
                                            },
                                            onError: { error in
                                                fail("\(error)")
                                                done()
                                            }
                                        )
                                        .disposed(by: self.disposeBag)
                                },
                                onError: { error in
                                    fail("\(error)")
                                    done()
                                }
                            )
                            .disposed(by: self.disposeBag)
                    }
                }
            }
        }
    }
}

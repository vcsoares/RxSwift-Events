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
        }
    }
}

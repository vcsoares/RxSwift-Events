//
//  CheckinViewModel.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 25/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class CheckinViewModel {
    enum ViewState {
        case presenting
        case sendingRequest
        case success
        case error
    }
    
    var name = BehaviorRelay<String?>(value: nil)
    var email = BehaviorRelay<String?>(value: nil)
    
    var hasValidData: Observable<Bool>
    var viewState: Observable<ViewState> {
        return state.asObservable().distinctUntilChanged()
    }
    
    private let event: Event
    private let state = BehaviorRelay<ViewState>(value: .presenting)
    private let disposeBag = DisposeBag()
    
    init(with event: Event) {
        self.event = event
        
        self.hasValidData = Observable.combineLatest(
            self.name.asObservable(),
            self.email.asObservable()
        )
        .map { (name, email) in
            guard let name = name,
                  let email = email,
                  !name.isEmpty,
                  !email.isEmpty
            else {
                return false
            }
            
            return true
        }
    }
    
    func checkin() {
        guard let name = self.name.value,
              let email = self.email.value else {
            self.state.accept(.error)
            return
        }
        
        self.state.accept(.sendingRequest)
        
        let person = Person(name: name, email: email)
        
        API.shared.checkin(user: person, to: event)
            .subscribe(
                onNext: { hasSucceeded in
                    if hasSucceeded {
                        self.state.accept(.success)
                    } else {
                        // it is possible for the HTTP request to succeed
                        // but the JSON response return an error code
                        self.state.accept(.error)
                    }
                },
                onError: { error in
                    print(error)
                    self.state.accept(.error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}

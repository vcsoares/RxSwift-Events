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
    var state: Observable<ViewState> {
        return stateRelay.asObservable().distinctUntilChanged()
    }
    
    private let event: Event
    private let stateRelay = BehaviorRelay<ViewState>(value: .presenting)
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
                  !email.isEmpty,
                  email.isValidEmail
            else {
                return false
            }
            
            return true
        }
    }
    
    func checkin() {
        guard let name = self.name.value,
              let email = self.email.value else {
            self.stateRelay.accept(.error)
            return
        }
        
        self.stateRelay.accept(.sendingRequest)
        
        let person = Person(name: name, email: email)
        
        API.shared.checkin(user: person, to: event)
            .timeout(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { hasSucceeded in
                    if hasSucceeded {
                        self.stateRelay.accept(.success)
                    } else {
                        // it is possible for the HTTP request to succeed
                        // but the JSON response return an error code
                        self.stateRelay.accept(.error)
                    }
                },
                onError: { error in
                    print(error)
                    self.stateRelay.accept(.error)
                }
            )
            .disposed(by: self.disposeBag)
    }
}

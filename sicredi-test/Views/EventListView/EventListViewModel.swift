//
//  EventListViewModel.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import Foundation
import RxCocoa
import RxSwift

class EventListViewModel: NSObject {
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    var observableEvents: Observable<[Event]> {
        return self.events.asObservable()
    }
    
    var state: BehaviorRelay<ViewState>
    
    private var events: BehaviorRelay<[Event]>
    private let disposeBag = DisposeBag()
    
    override init() {
        self.state = BehaviorRelay(value: .loading)
        self.events = BehaviorRelay(value: [])
        super.init()
    }
    
    func fetchEvents() {
        self.state.accept(.loading)
        
        API.shared.fetchEvents()
            .timeout(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { events in
                    self.events.accept(events)
                    self.state.accept(.loaded)
                },
                onError: { error in
                    self.events.accept([])
                    self.state.accept(.error)
                }
            )
            .disposed(by: disposeBag)
    }
    
}

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
    var observableEvents: Observable<[Event]>
    enum ViewState {
        case loading
        case loaded
        case error
    }
    
    var state: BehaviorRelay<ViewState>
    
    private let disposeBag = DisposeBag()
    
    override init() {
        self.observableEvents = API.shared.fetchEvents()
        self.state = BehaviorRelay(value: .loading)
        super.init()
    }
    
    func bind(tableView: UITableView) {
        self.observableEvents
            .bind(to: tableView.rx.items(
                    cellIdentifier: "event-cell",
                    cellType: UITableViewCell.self)
            ) { (row, element, cell) in
                cell.textLabel?.text = element.title
                cell.detailTextLabel?.text = String(format: "R$ %.2f", element.price)
            }
            .disposed(by: self.disposeBag)
    }
}

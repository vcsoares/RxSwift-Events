//
//  EventListViewController.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class EventListViewController: UIViewController {

    @IBOutlet weak var eventListTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = EventListViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTableView.delegate = self
        
        self.bindComponents()
        self.viewModel.fetchEvents()
    }
    
    // MARK: - Component binding
    private func bindComponents() {
        // Check whether we are done fetching Events from the API, and hide
        // activity indicator accordingly. If something fails along the way,
        // present an error alert.
        self.viewModel.state
            .subscribe(
                onNext: { state in
                    switch state {
                    case .loading:
                        self.activityIndicator.startAnimating()
                    case .presenting:
                        self.activityIndicator.stopAnimating()
                    case .error:
                        self.activityIndicator.stopAnimating()
                        self.presentErrorAlert {
                            self.viewModel.fetchEvents()
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // Bind fetched events to our table view cells
        self.viewModel.observableEvents
            .bind(to: eventListTableView.rx.items(
                    cellIdentifier: "event-cell",
                    cellType: EventListTableViewCell.self)
            ) { (row, event, cell) in
                cell.titleLabel.text = event.title
                cell.dateLabel.text = event.date.shortDateString
                cell.priceLabel.text = String.priceString(from: event.price)
                cell.eventImageView.kf.setImage(
                    with: URL(string: event.image),
                    options: [
                        .transition(.fade(1)),
                        .onFailureImage(UIImage(systemName: "photo.on.rectangle.angled")),
                    ]
                )
            }
            .disposed(by: self.disposeBag)
        
        // Retrieves the Event that corresponds to the selected cell, and
        // passes it onto its Details page.
        eventListTableView.rx.modelSelected(Event.self)
            .flatMapLatest { event -> Observable<Event> in
                API.shared.fetchEvent(with: event.id)
                    .timeout(.seconds(5), scheduler: MainScheduler.instance)
            }
            .catch { error in
                print(error)
                if let selectedIndexPath = self.eventListTableView.indexPathForSelectedRow {
                    self.eventListTableView.deselectRow(at: selectedIndexPath, animated: true)
                }
                
                self.presentErrorAlert {
                    self.viewModel.state.accept(.presenting)
                }
                
                return Observable.error(error)
            }
            .retry()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(
                onNext: { event in
                    guard let selectedIndexPath = self.eventListTableView.indexPathForSelectedRow
                    else {
                        return
                    }
                    self.eventListTableView.deselectRow(at: selectedIndexPath, animated: true)
                    self.performSegue(withIdentifier: "show-details", sender: event)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Alerts
    private func presentErrorAlert(completionHandler: (() -> Void)?) {
        let alert = UIAlertController(
            title: "Algo deu errado!",
            message: nil,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Tentar novamente",
                style: .default,
                handler: { _ in
                    completionHandler?()
                }
            )
        )
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show-details" {
            guard
                let eventDetailsViewController = segue.destination as? EventDetailsViewController,
                let event = sender as? Event
            else {
                print("**** unable to present event details! ****")
                return
            }
            
            eventDetailsViewController.viewModel = EventDetailsViewModel(with: event)
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "show-details" {
            guard (sender as? Event) != nil
            else {
                // should this ever fail for whatever reason...
                print("**** unable to present event details! ****")
                self.presentErrorAlert {
                    self.viewModel.state.accept(.presenting)
                }
                return false
            }
        }
        
        return true
    }
}

// MARK: - UITableViewDelegate extensions
extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

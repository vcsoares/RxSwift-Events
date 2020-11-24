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
                    case .loaded:
                        self.activityIndicator.stopAnimating()
                    case .error:
                        self.activityIndicator.stopAnimating()
                        self.presentErrorAlert()
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // Bind fetched events to our table view cells
        self.viewModel.observableEvents
            .bind(to: eventListTableView.rx.items(
                    cellIdentifier: "event-cell",
                    cellType: EventListTableViewCell.self)
            ) { (row, element, cell) in
                cell.titleLabel.text = element.title
                cell.priceLabel.text = String(format: "R$ %.2f", element.price)
                cell.eventImageView.kf.setImage(
                    with: URL(string: element.image),
                    placeholder: UIImage(systemName: "photo.on.rectangle.angled"),
                    options: [ .transition(.fade(1)) ]
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
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(
                onNext: { event in
                    guard let selectedIndexPath = self.eventListTableView.indexPathForSelectedRow
                    else {
                        return
                    }
                    self.eventListTableView.deselectRow(at: selectedIndexPath, animated: true)
                    self.performSegue(withIdentifier: "show-details", sender: event)
                },
                onError: { error in
                    print(error)
                    guard let selectedIndexPath = self.eventListTableView.indexPathForSelectedRow
                    else {
                        return
                    }
                    self.eventListTableView.deselectRow(at: selectedIndexPath, animated: true)
                    self.presentErrorAlert()
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Alerts
    private func presentErrorAlert() {
        let alert = UIAlertController(
            title: "Algo deu errado!",
            message: "Verifique sua conexão e tente novamente.",
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        
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
                self.presentErrorAlert()
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

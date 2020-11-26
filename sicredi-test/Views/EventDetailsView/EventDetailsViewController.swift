//
//  EventDetailsViewController.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import UIKit
import MapKit
import Kingfisher
import RxCocoa
import RxSwift

class EventDetailsViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var eventView: UITableView!
        
    var viewModel: EventDetailsViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else {
            return
        }
        
        self.titleLabel.text = viewModel.event.title
        self.dateLabel.text = viewModel.event.date.shortDateTimeString
        self.priceLabel.text = String(format: "R$ %.2f", viewModel.event.price)
        self.descriptionTextView.text = viewModel.event.description
        self.checkinButton.layer.cornerRadius = 16
        
        self.eventImageView.kf.indicatorType = .activity
        self.eventImageView.kf.setImage(
            with: URL(string: viewModel.event.image),
            options: [
                .transition(.fade(1)),
                .onFailureImage(UIImage(systemName: "photo.on.rectangle.angled"))
            ]
        )
        
        let annotation = MKPlacemark(coordinate: viewModel.location)
        let region = MKCoordinateRegion(
            center: viewModel.location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        
        self.locationMapView.addAnnotation(annotation)
        self.locationMapView.setRegion(region, animated: true)

        viewModel.address
            .bind(to: self.addressTextView.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show-checkin" {
            guard let destination = segue.destination as? CheckinViewController,
                  let viewModel = self.viewModel
            else {
                return
            }
            
            destination.viewModel = CheckinViewModel(with: viewModel.event)
        }
    }
    
    @IBAction func didPressShareButton(_ sender: Any) {
        guard let viewModel = self.viewModel else {
            return
        }
        
        let shareSheet = UIActivityViewController(
            activityItems: viewModel.shareItems,
            applicationActivities: nil
        )
        
        self.present(shareSheet, animated: true, completion: nil)
    }
    
    // MARK: - Styling
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.tintColor = .white
        }
    }
}

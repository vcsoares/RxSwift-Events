//
//  EventDetailsViewController.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class EventDetailsViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBOutlet weak var eventView: UITableView!
        
    var viewModel: EventDetailsViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = self.viewModel else {
            return
        }
        
        self.titleLabel.text = viewModel.event.title
        self.priceLabel.text = String(format: "R$ %.2f", viewModel.event.price)
        self.descriptionLabel.text = viewModel.event.description
        self.checkinButton.layer.cornerRadius = 16
        
        self.eventImageView.kf.indicatorType = .activity
        self.eventImageView.kf.setImage(
            with: URL(string: viewModel.event.image),
            options: [
                .transition(.fade(1)),
                .onFailureImage(UIImage(systemName: "photo.on.rectangle.angled"))
            ]
        )
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

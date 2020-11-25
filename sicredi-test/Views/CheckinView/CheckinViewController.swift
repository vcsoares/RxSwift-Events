//
//  CheckinViewController.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 25/11/20.
//

import UIKit
import RxCocoa
import RxSwift

class CheckinViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CheckinViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkinButton.layer.cornerRadius = 16
        
        self.bindComponents()
    }

    private func bindComponents() {
        guard let viewModel = self.viewModel else {
            return
        }
        
        viewModel.viewState
            .subscribe(
                onNext: { state in
                    switch state {
                    case .presenting:
                        self.activityIndicator.stopAnimating()
                        break
                    case .sendingRequest:
                        self.activityIndicator.startAnimating()
                        print("sending checkin request...")
                        break
                    case .success:
                        self.activityIndicator.stopAnimating()
                        // show success alert
                        print("...done!")
                        self.dismiss(animated: true, completion: nil)
                    case .error:
                        self.activityIndicator.stopAnimating()
                        // show error alert
                        print("something went wrong!")
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        // Disables and dims check-in button if there are any empty
        // textfields on-screen, or if no valid e-mail has been entered.
        viewModel.hasValidData
            .bind(to: self.checkinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.hasValidData
            .distinctUntilChanged()
            .map { hasValidData -> CGFloat in
                return hasValidData ? 1 : 0.5
            }
            .bind(to: self.checkinButton.rx.alpha)
            .disposed(by: disposeBag)
        
        // Bind textfield inputs to corresponding view model attributes
        self.nameTextField.rx.text
            .distinctUntilChanged()
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        self.emailTextField.rx.text
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        // Post check-in request when check-in button has been tapped
        self.checkinButton.rx.tap
            .subscribe(
                onNext: { viewModel.checkin() }
            )
            .disposed(by: disposeBag)

        // Dismiss modal when close button tapped
        self.closeButton.rx.tap
            .subscribe(
                onNext: { self.dismiss(animated: true, completion: nil) }
            )
            .disposed(by: disposeBag)
    }
}

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
                        break
                    case .sendingRequest:
                        // show activity indicator
                        print("sending checkin request...")
                        break
                    case .success:
                        // show success alert
                        print("...done!")
                        self.dismiss(animated: true, completion: nil)
                    case .error:
                        // show error alert
                        print("something went wrong!")
                        break
                    }
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.hasValidData
            .bind(to: self.checkinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.nameTextField.rx.text
            .distinctUntilChanged()
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)
        
        self.emailTextField.rx.text
            .distinctUntilChanged()
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        self.checkinButton.rx.tap
            .subscribe(
                onNext: { viewModel.checkin() }
            )
            .disposed(by: disposeBag)
    }
}

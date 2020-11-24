//
//  EventDetailsViewController.swift
//  sicredi-test
//
//  Created by Vinícius Chagas on 23/11/20.
//

import UIKit
import RxCocoa
import RxSwift

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var viewModel: EventDetailsViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        self.testLabel.text = viewModel.event.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

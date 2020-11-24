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
    
    private var viewModel = EventListViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventListTableView.delegate = self
        
        self.viewModel.bind(tableView: eventListTableView)
        
        eventListTableView.rx.modelSelected(Event.self)
            .subscribe(
                onNext: { event in
                    print(event)
                }
            )
            .disposed(by: disposeBag)
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

extension EventListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

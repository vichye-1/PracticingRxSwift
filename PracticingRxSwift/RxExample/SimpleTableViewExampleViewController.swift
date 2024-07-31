//
//  SimpleTableViewExampleViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewExampleViewController: BaseViewController, UITableViewDelegate {
    
    private let disposeBag = DisposeBag()
    private let identifier = "Cell"
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                let alertView = UIAlertController(title: "modelSelected", message: "\(value)", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alertView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { [weak self] indexPath in
                let alertView = UIAlertController(title: "itemAccessoryButtonTapped", message: "\(indexPath)", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alertView, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        //view.backgroundColor = .yellow
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

//
//  TableViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TableViewController: BaseViewController {
    let disposeBag = DisposeBag()
    let simpleTableView = UITableView()
    let simpleLabel = UILabel()
    
    // MARK: - UI Components
    override func configureHierarchy() {
        [simpleTableView, simpleLabel].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.3)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(simpleTableView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(80)
        }
    }
    
    override func configureView() {
        simpleLabel.backgroundColor = .lightGray
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    private func setTableView() {
        let identifier = "Cell"
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        items
            .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
                cell.textLabel?.text = "\(element) @ row \(row)"
                return cell
            }
            .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

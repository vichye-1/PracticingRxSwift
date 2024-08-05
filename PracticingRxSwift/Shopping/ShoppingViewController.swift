//
//  ShoppingViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct ShoppingItem {
    var bought: Bool
    let wantToBuy: String
    var favorite: Bool
}

final class ShoppingViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    
    private let backgroundView = {
       let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = .systemGray6
        return view
    }()
    private let addTextField = {
        let textField = UITextField()
        textField.placeholder = "무엇을 구매하실 건가요?"
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        return textField
    }()
    private let addButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    private let shoppingTableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var items = BehaviorRelay<[ShoppingItem]>(value: [
        ShoppingItem(bought: false, wantToBuy: "에어팟 맥스", favorite: true),
        ShoppingItem(bought: false, wantToBuy: "아이폰16Pro 1TB", favorite: false),
        ShoppingItem(bought: true, wantToBuy: "애플워치 신형", favorite: true),
        ShoppingItem(bought: true, wantToBuy: "모니터", favorite: false)
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - UI configuration
    override func configureHierarchy() {
        [backgroundView, addTextField, addButton, shoppingTableView].forEach { view.addSubview($0) }
    }
    override func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(80)
        }
        addTextField.snp.makeConstraints { make in
            make.verticalEdges.equalTo(backgroundView.snp.verticalEdges).inset(10)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
        }
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundView.snp.trailing).inset(8)
            make.leading.equalTo(addTextField.snp.trailing).offset(16)
            make.verticalEdges.equalTo(backgroundView).inset(20)
            make.width.equalTo(55)
        }
        shoppingTableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        let identifier = ShoppingTableViewCell.identifier
        items
            .bind(to: shoppingTableView.rx.items(cellIdentifier: identifier, cellType: ShoppingTableViewCell.self)) { (row, item, cell) in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
    }
    
}

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
    private let viewModel = ShoppingViewModel()
    private let checkButtonClicked = PublishRelay<Int>()
    private let favoriteButtonClicked = PublishRelay<Int>()
    
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
    private let shoppingCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        return view
    }()
    
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    private let shoppingTableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: ShoppingTableViewCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - UI configuration
    override func configureHierarchy() {
        [backgroundView, addTextField, addButton, shoppingCollectionView, shoppingTableView].forEach { view.addSubview($0) }
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
        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        shoppingTableView.snp.makeConstraints { make in
            make.top.equalTo(shoppingCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        shoppingCollectionView.register(ShoppingCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingCollectionViewCell.identifier)
    }
    
    private func bind() {
        let input = ShoppingViewModel.Input(
            addButtonTapped: addButton.rx.tap.asObservable(),
            newItem: addTextField.rx.text.orEmpty.asObservable(),
            checkButtonTapped: checkButtonClicked.asObservable(),
            favoriteButtonTapped: favoriteButtonClicked.asObservable(),
            collectionViewItemSelected: shoppingCollectionView.rx.modelSelected(String.self).asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.recentList
            .bind(to: shoppingCollectionView.rx.items(cellIdentifier: ShoppingCollectionViewCell.identifier, cellType: ShoppingCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(text: element)
            }
            .disposed(by: disposeBag)
        
        output.items
            .drive(shoppingTableView.rx.items(cellIdentifier: ShoppingTableViewCell.identifier, cellType: ShoppingTableViewCell.self)) { [weak self] (row, element, cell) in
                cell.configure(item: element)
                
                guard let self = self else { return }
                
                cell.checkmarkTapped
                    .map { row }
                    .bind(to: self.checkButtonClicked)
                    .disposed(by: cell.disposeBag)
                
                cell.favoriteTapped
                    .map { row }
                    .bind(to: self.favoriteButtonClicked)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

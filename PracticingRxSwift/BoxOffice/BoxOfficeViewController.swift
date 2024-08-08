//
//  BoxOfficeViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: BaseViewController {
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let viewModel = BoxOfficeViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        let input = BoxOfficeViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty)
        let output = viewModel.transform(input: input)
        
        input.searchButtonTap
            .subscribe(with: self) { owner, _ in
                print("뷰컨트롤러 서치 버튼 탭 인식")
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .subscribe(with: self) { owner, _ in
                print("뷰컨트롤러 서치 텍스트 인식")
            }
            .disposed(by: disposeBag)
        
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier, cellType: BoxOfficeTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = element.movieNm
                cell.downloadButton.setTitle(element.openDt, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureView() {
        view.backgroundColor = .white
        
        [searchBar, tableView].forEach { view.addSubview($0) }
        
        navigationItem.titleView = searchBar // 이렇게하면 네비게이션 바에 제목없이 바로 서치바를 넣을 수 있음
        
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: BoxOfficeTableViewCell.identifier)
        tableView.backgroundColor = .systemGreen
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

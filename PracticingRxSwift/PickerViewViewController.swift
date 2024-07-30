//
//  PickerViewViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PickerViewViewController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    let simplePickerView = UIPickerView()
    let simpleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
    }
    
    override func configureHierarchy() {
        [simplePickerView, simpleLabel].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        simplePickerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(80)
        }
    }
    
    override func configureView() {
        simpleLabel.textAlignment = .center
        simpleLabel.backgroundColor = .systemMint
    }
    
    private func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        items
            .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }
            .disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

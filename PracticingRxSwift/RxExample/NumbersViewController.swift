//
//  NumbersViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class NumbersViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let result = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.combineLatest(number1.rx.text.orEmpty, number2.rx.text.orEmpty, number3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
        .map { $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [number1, number2, number3, result].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        number1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        
        result.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        number1.backgroundColor = .systemGray2
        number2.backgroundColor = .systemGray3
        number3.backgroundColor = .systemGray4
        result.backgroundColor = .systemGray5
    }
}

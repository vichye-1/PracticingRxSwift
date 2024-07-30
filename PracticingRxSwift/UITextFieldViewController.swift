//
//  UITextFieldViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class UITextFieldViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let signNameTextField = UITextField()
    private let signEmailTextField = UITextField()
    private let simpleLabel = UILabel()
    private let signButton = UIButton()
    
    override func configureHierarchy() {
        [signNameTextField, signEmailTextField, simpleLabel, signButton].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        signNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        signEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(signNameTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        simpleLabel.snp.makeConstraints { make in
            make.top.equalTo(signEmailTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        signButton.snp.makeConstraints { make in
            make.top.equalTo(simpleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        signNameTextField.backgroundColor = .systemGray5
        signNameTextField.placeholder = "inset name"
        signEmailTextField.backgroundColor = .systemGray4
        signEmailTextField.placeholder = "insert email"
        simpleLabel.backgroundColor = .systemGray3
        signButton.backgroundColor = .systemGray2
        signButton.setTitle("Sign In", for: .normal)
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSign()
    }
    
    private func setSign() {
        Observable.combineLatest(signNameTextField.rx.text.orEmpty, signEmailTextField.rx.text.orEmpty) { name, email in
            return "이름은 \(name)이고, 이메일은 \(email)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signNameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: signEmailTextField.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmailTextField.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "로그인", message: "로그인에 성공하셨습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

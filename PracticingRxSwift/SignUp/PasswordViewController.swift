//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordViewController: BaseViewController {
   
    private let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    private let descriptionLabel = UILabel()
    
    private let viewModel = PasswordViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        disposeBag = DisposeBag()
    }
    
    private func bind() {
        let input = PasswordViewModel.Input(
            password: passwordTextField.rx.text.orEmpty.asObservable(),
            nextButtonTap: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isvalid
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.descriptionText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonColor
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.nextButtonColor
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        output.descriptionLabelHidden
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.navigateToPhoneVC
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(PhoneViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(passwordTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        descriptionLabel.font = .systemFont(ofSize: 13)
    }
}

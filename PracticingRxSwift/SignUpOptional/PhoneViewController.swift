//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class PhoneViewController: BaseViewController {
   
    private var disposeBag = DisposeBag()
    
    private let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    private let nextButton = PointButton(title: "다음")
    private let descriptionLabel = UILabel()
    
    private let phoneData = BehaviorSubject(value: "010")
    private let validText = Observable.just("10자 이상의 숫자를 입력해주세요")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        disposeBag = DisposeBag()
        bind()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
    }
    
    private func bind() {
        validText.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = phoneTextField.rx.text.orEmpty
            .map { text in
                return text.allSatisfy { $0.isNumber } && text.count >= 10 }
        
        validation.bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                owner.descriptionLabel.isHidden = value
                owner.descriptionLabel.textColor = .systemRed
            }
            .disposed(by: disposeBag)
        
        
        phoneData.bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, value in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    
    override func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(phoneTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        descriptionLabel.font = .systemFont(ofSize: 13)
    }

}

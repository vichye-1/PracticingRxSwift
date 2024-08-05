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
   private let viewModel = PhoneViewModel()
    private var disposeBag = DisposeBag()
    
    private let phoneTextField = SignTextField(placeholderText: PlaceHolder.textField.defaultString)
    private let nextButton = PointButton(title: "다음")
    private let descriptionLabel = UILabel()
    
    private let phoneData = BehaviorRelay(value: "010")
    private let validText = BehaviorSubject(value: PlaceHolder.description.defaultString)
    
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
        let input = PhoneViewModel.Input(phoneNumber: phoneTextField.rx.text.orEmpty, nextButtonTap: nextButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.isNextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextButtonColor
            .drive(nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        
        output.descriptionText
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validationState
            .map { $0 == .valid }
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.navigateToNext
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(NicknameViewController(), animated: true)
            })
            .disposed(by: disposeBag)
        
        phoneData.bind(to: phoneTextField.rx.text)
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

extension PhoneViewController {
    private enum PlaceHolder {
        case textField
        case description
        
        var defaultString: String {
            switch self {
            case .textField:
                return "연락처를 입력해주세요"
            case .description:
                return "10자리 이상의 숫자를 입력해주세요"
            }
        }
    }
}

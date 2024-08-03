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
    private enum ValidationState {
        case invalidCharacters
        case tooShort
        case valid
    }
   
    private var disposeBag = DisposeBag()
    
    private let phoneTextField = SignTextField(placeholderText: PlaceHolder.textField.defaultString)
    private let nextButton = PointButton(title: "다음")
    private let descriptionLabel = UILabel()
    
    private let phoneData = BehaviorSubject(value: "010")
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
        validText.bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let inputPhoneNumber = phoneTextField.rx.text.orEmpty
        
        let validationState = inputPhoneNumber
            .map { text -> ValidationState in
                if !text.allSatisfy({$0.isNumber}) {
                    return .invalidCharacters
                } else if text.count < 10 {
                    return .tooShort
                } else {
                    return .valid
                }
            }
        
        validationState.map { state -> String in
            switch state {
            case .invalidCharacters:
                return Errors.stringError.errorString
            case .tooShort:
                return Errors.lengthError.errorString
            case .valid:
                return ""
            }
        }
        .bind(to: descriptionLabel.rx.text)
        .disposed(by: disposeBag)
        
        validationState
            .map{ $0 == .valid }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validationState
            .bind(with: self) { owner, state in
                let color: UIColor = state == .valid ? .systemBlue : .systemGray
                owner.nextButton.backgroundColor = color
                owner.descriptionLabel.isHidden = state == .valid
                owner.descriptionLabel.textColor = .systemRed
            }
            .disposed(by: disposeBag)
        
        phoneData.bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
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

extension PhoneViewController {
    private enum Errors {
        case stringError
        case lengthError
        
        var errorString: String {
            switch self {
            case .stringError:
                return "숫자만 입력해주세요"
            case .lengthError:
                return "10자 이상 입력해주세요"
            }
        }
    }
    
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

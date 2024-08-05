//
//  PhoneViewModel.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneViewModel {
    enum ValidationState {
        case invalidCharacters
        case tooShort
        case valid
    }

    struct Input {
        let phoneNumber: ControlProperty<String>
        let nextButtonTap: Observable<Void>
    }
    
    struct Output {
        let validationState: Driver<ValidationState>
        let isNextButtonEnabled: Driver<Bool>
        let nextButtonColor: Driver<UIColor>
        let descriptionText: Driver<String>
        let navigateToNext: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let validationState = input.phoneNumber
            .map { text -> ValidationState in
                if !text.allSatisfy({$0.isNumber}) {
                    return .invalidCharacters
                } else if text.count < 10 {
                    return .tooShort
                } else {
                    return .valid
                }
            }
            .asDriver(onErrorJustReturn: .invalidCharacters)
        
        let isNextButtonEnabled = validationState.map { $0 == .valid}
        
        let nextButtonColor = validationState.map { $0 == .valid ? UIColor.systemBlue : UIColor.systemGray}
        
        let descriptionText = validationState.map{ state -> String in
            switch state {
            case .invalidCharacters:
                return Errors.stringError.errorString
            case .tooShort:
                return Errors.lengthError.errorString
            case .valid:
                return ""
            }
        }
        
        let navigateToNext = input.nextButtonTap.asDriver(onErrorJustReturn: ())
        
        return Output(validationState: validationState, isNextButtonEnabled: isNextButtonEnabled, nextButtonColor: nextButtonColor, descriptionText: descriptionText, navigateToNext: navigateToNext)
        
    }
    
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
    
}

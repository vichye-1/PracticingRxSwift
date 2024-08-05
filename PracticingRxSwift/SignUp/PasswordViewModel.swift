//
//  PasswordViewModel.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/5/24.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    struct Input {
        let password: Observable<String>
        let nextButtonTap: Observable<Void>
    }
    
    struct Output {
        let isvalid: Driver<Bool>
        let descriptionText: Driver<String>
        let nextButtonEnabled: Driver<Bool>
        let nextButtonColor: Driver<UIColor>
        let descriptionLabelHidden: Driver<Bool>
        let navigateToPhoneVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.password
            .map { $0.count >= 8 }
        let isValidPassword = validation.asDriver(onErrorJustReturn: false)
        let validText = Observable.just("8자 이상 입력해주세요").asDriver(onErrorJustReturn: "")
        let nextButtonEnabled = isValidPassword
        let nextButtonColor = isValidPassword.map { $0 ? UIColor.systemBlue: UIColor.systemGray }
        let descriptionLabelHidden = isValidPassword
        let navigateToPhonveVC = input.nextButtonTap.asDriver(onErrorJustReturn: ())
        return Output(isvalid: isValidPassword,
                      descriptionText: validText,
                      nextButtonEnabled: nextButtonEnabled,
                      nextButtonColor: nextButtonColor,
                      descriptionLabelHidden: descriptionLabelHidden, navigateToPhoneVC: navigateToPhonveVC
        )
    }
}

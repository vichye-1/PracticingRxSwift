//
//  SimpleValidationViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/1/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

private let minimalUsernameLength = 5
private let minimalPasswordLength = 5

class SimpleValidationViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    private let usernameOutlet = UITextField()
    private let usernameValidOutlet = UILabel()
    
    private let passwordOutlet = UITextField()
    private let passwordValidOutlet = UILabel()
    
    private let doSomethingOutlet = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        doSomethingOutlet.setTitle("Are you ready?", for: .normal)
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [usernameOutlet, usernameValidOutlet, passwordOutlet, passwordValidOutlet, doSomethingOutlet].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        usernameOutlet.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        usernameValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameOutlet.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        passwordOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        passwordValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordOutlet.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(32)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(44)
        }
    }
    
    override func configureView() {
        usernameOutlet.backgroundColor = .systemGray
        //usernameValidOutlet.backgroundColor = .systemGray2
        passwordOutlet.backgroundColor = .systemGray3
        //passwordValidOutlet.backgroundColor = .systemGray4
        doSomethingOutlet.backgroundColor = .systemGreen
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Success!", message: "This is wonderful🍀", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true)
    }
}

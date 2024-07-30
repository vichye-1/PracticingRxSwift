//
//  UISwitchViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class UISwitchViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let simpleSwitch = UISwitch()
    private let simpleLabel = UILabel()
    
    override func configureView() {
        view.addSubview(simpleSwitch)
        view.addSubview(simpleLabel)
        simpleSwitch.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        simpleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.height.equalTo(80)
        }
        simpleLabel.backgroundColor = .lightGray
    }
    
    // MARK: - view LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwitch()
    }
    
    private func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}

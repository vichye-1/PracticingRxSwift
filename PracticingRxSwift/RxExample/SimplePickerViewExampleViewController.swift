//
//  SimplePickerViewExampleViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimplePickerViewExampleViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let pickerView1 = UIPickerView()
    private let pickerView2 = UIPickerView()
    private let pickerView3 = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                    return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                    print("models selected 1: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.cyan, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue])
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                    print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                    print("models selected 3: \(models)")
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [pickerView1, pickerView2, pickerView3].forEach { view.addSubview($0) }
    }
    
    override func configureLayout() {
        pickerView1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
        
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
        
        pickerView3.snp.makeConstraints { make in
            make.top.equalTo(pickerView2.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(120)
        }
    }
}

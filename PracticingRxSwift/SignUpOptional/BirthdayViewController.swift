//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class BirthdayViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let infoData = BehaviorRelay(value: InfoStatus.initial.infoLabelString)
    private let isValidAge = BehaviorRelay(value: false)
    
    private let year = BehaviorRelay(value: 2024)
    private let month = BehaviorRelay(value: 8)
    private let day = BehaviorRelay(value: 3)
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        return formatter
    }()
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.text = "2023년"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.text = "33월"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.text = "99일"
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    // MARK: - View LifeCycle
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
    
    // MARK: - custom functions
    private func bind() {
        // infoData 문구 infoLabel에 삽입하는 코드
        infoData.bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 날짜 변경 감지 - updateDateLabel function 사용
        birthDayPicker.rx.date
            .bind(with: self) { owner, date in
                owner.updateDateLabels(date: date)
            }
            .disposed(by: disposeBag)
        
        year
            .map { "\($0)년" }
            .bind(to: yearLabel.rx.text)
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" }
            .bind(to: monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
       
        Observable.combineLatest(year, month, day)
            .map { year, month, day in
                if let birthday = DateComponents(calendar: .current, year: year, month: month, day: day).date {
                    let age = Calendar.current.dateComponents([.year], from: birthday, to: Date()).year ?? 0
                    return age >= 17
                }
                return false
            }
            .bind(to: isValidAge)
            .disposed(by: disposeBag)
        
        isValidAge
            .map { $0 ? InfoStatus.valid : InfoStatus.invalid }
            .map { $0.infoLabelString }
            .bind(to: infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        isValidAge
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isValidAge
            .map { $0 ? UIColor.systemBlue: UIColor.systemGray}
            .bind(to: nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SearchViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateDateLabels(date: Date) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        year.accept(components.year ?? 2024)
        month.accept(components.month ?? 1)
        day.accept(components.day ?? 1)
        
        if let birthDate = Calendar.current.date(from: components),
           let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year {
            isValidAge.accept(age >= 17)
        } else {
            isValidAge.accept(false)
        }
    }
    
    // MARK: - UI configuration
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}

extension BirthdayViewController {
    private enum InfoStatus {
        case invalid
        case valid
        case initial
        
        var infoLabelString: String {
            switch self {
            case .invalid:
                return "만 17세 이상만 가입 가능합니다"
            case .valid:
                return "가입 가능한 나이입니다"
            case .initial:
                return "만 17세 이상만 가입 가능합니다"
            }
        }
    }
}

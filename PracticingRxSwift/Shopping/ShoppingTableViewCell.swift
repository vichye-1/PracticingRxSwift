//
//  ShoppingTableViewCell.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ShoppingTableViewCell: BaseTableViewCell {
    var disposeBag = DisposeBag()
    
    var checkmarkTapped: ControlEvent<Void> {
        return checkmarkButton.rx.tap
    }
    
    var favoriteTapped: ControlEvent<Void> {
        return favoriteButton.rx.tap
    }
    
    private let checkmarkButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let favoriteButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        [checkmarkButton, titleLabel, favoriteButton].forEach { contentView.addSubview($0) }
    }
    
    override func configureLayout() {
        checkmarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(favoriteButton.snp.leading).offset(-10)
        }
        favoriteButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    override func configureUI() {
        contentView.backgroundColor = .systemGray6
    }
    
    func configure(item: ShoppingItem) {
        titleLabel.text = item.wantToBuy
        checkmarkButton.setImage(UIImage(systemName: item.bought ? "checkmark.square": "square"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: item.favorite ? "star.fill" : "star"), for: .normal)
    }
}

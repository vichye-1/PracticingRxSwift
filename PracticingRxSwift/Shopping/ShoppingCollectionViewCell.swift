//
//  ShoppingCollectionViewCell.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/7/24.
//

import UIKit
import SnapKit

final class ShoppingCollectionViewCell: BaseCollectionViewCell {
    let label = UILabel()
    
    override func configureUI() {
        contentView.addSubview(label)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    func configure(text: String) {
        label.text = text
    }
}

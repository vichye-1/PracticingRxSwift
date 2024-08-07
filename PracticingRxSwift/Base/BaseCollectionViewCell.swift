//
//  BaseCollectionViewCell.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/7/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureUI() { }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  File.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

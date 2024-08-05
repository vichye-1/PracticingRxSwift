//
//  UIView+.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 8/5/24.
//

import UIKit

extension UIView: ReuseidentifierProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}

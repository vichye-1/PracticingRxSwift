//
//  BaseViewController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/30/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
    }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
}

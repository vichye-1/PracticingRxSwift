//
//  RxExampleTabBarController.swift
//  PracticingRxSwift
//
//  Created by 양승혜 on 7/31/24.
//

import UIKit

final class RxExampleTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = PickerViewController()
        let pickerNav = UINavigationController(rootViewController: picker)
        pickerNav.tabBarItem = UITabBarItem(title: "pickerView", image: UIImage(systemName: "mappin"), tag: 0)
        
        let tableView = TableViewController()
        let tableViewNav = UINavigationController(rootViewController: tableView)
        tableViewNav.tabBarItem = UITabBarItem(title: "tableView", image: UIImage(systemName: "table"), tag: 1)

        let switchView = UISwitchViewController()
        let switchNav = UINavigationController(rootViewController: switchView)
        switchNav.tabBarItem = UITabBarItem(title: "UISwitch", image: UIImage(systemName: "switch.2"), tag: 2)

        let textfield = UITextFieldViewController()
        let textFieldNav = UINavigationController(rootViewController: textfield)
        textFieldNav.tabBarItem = UITabBarItem(title: "textField", image: UIImage(systemName: "person"), tag: 3)

        // set tabBarController
        setViewControllers([pickerNav, tableViewNav, switchNav, textFieldNav], animated: true)
    }
}



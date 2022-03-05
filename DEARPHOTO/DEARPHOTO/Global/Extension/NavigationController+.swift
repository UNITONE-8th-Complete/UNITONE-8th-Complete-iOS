//
//  NavigationController+.swift
//  DEARPHOTO
//
//  Created by 황윤경 on 2022/03/06.
//

import UIKit

extension UINavigationController {
    func setSubNaviBarTitle(navigationItem: UINavigationItem?, title: String) {
        navigationItem!.title = title
    }

    func setNaviItemTintColor(navigationController: UINavigationController?, color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}

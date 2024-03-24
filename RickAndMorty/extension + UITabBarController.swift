//
//  extension + UITabBarController.swift
//  ApiTest2
//
//  Created by Владислав Соколов on 24.03.2024.
//

import Foundation
import UIKit

extension UITabBarController {
    func scrollToTop() {
        if let navController = selectedViewController as? UINavigationController,
           let topViewController = navController.topViewController as? CharacterCollection {
            topViewController.scrollToTop()
        }
    }
}

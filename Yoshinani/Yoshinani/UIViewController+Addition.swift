//
//  UIViewController+Addition.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import REFrostedViewController

extension UIViewController {
    func popToNewUserController () {
        let newRootVC = NewUserViewController(nibName: "NewUserViewController", bundle:nil)
        let MenuNC = MenuNavigationController(rootViewController: newRootVC)
        let menuVC = MenuTableViewController()
        
        let frostedVC = REFrostedViewController(contentViewController: MenuNC, menuViewController: menuVC)
        frostedVC.direction = REFrostedViewControllerDirection.Left;

        UIApplication.sharedApplication().keyWindow?.rootViewController = frostedVC
    }
}

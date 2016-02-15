//
//  MenuNavigationController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/27.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class MenuNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func showMenu () {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController .presentMenuViewController()
    }
}

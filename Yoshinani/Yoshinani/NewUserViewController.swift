//
//  NewUserViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RealmManager.sharedInstance.deleteUserInfo()
        // Do any additional setup after loading the view.
    }
    @IBAction func pushToLoginViewController(sender: AnyObject) {
        let vc = LogInViewController(nibName :"LogInViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pushToSignupViewController(sender: AnyObject) {
        let vc = SignUpViewController(nibName :"SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

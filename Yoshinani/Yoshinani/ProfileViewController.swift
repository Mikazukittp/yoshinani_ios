//
//  ProfileViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

        self.title = "Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self.navigationController, action:Selector("showMenu"))
        
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        
        if let nonNilUser = user {
            userNameLabel.text = nonNilUser.userName
        }else {
            //ユーザ情報がないので強制的にTOPに戻す
            self.popToNewUserController()
        }
    }
}

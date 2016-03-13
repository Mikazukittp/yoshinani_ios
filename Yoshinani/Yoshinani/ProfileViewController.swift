//
//  ProfileViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: BaseViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

        self.title = "プロフィール"
        self.screenTitle = "プロフィール画面(iOS)"
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.addTarget(self.navigationController, action: "showMenu", forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        
        if let nonNilUser = user {
            userNameLabel.text = nonNilUser.userName
            accountName.text = nonNilUser.account
            addressLabel.text = nonNilUser.email ?? "-"
        }else {
            //ユーザ情報がないので強制的にTOPに戻す
            self.popToNewUserController()
        }
    }
    @IBAction func didTapPasswordButton(sender: AnyObject) {
        let vc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle:nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  TermsOfServiceViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/29.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "利用規約"
        self.edgesForExtendedLayout = .None
   }

    func setLeftButton() {
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.addTarget(self.navigationController, action: "showMenu", forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
    }
}

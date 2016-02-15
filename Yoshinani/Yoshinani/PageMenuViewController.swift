//
//  PageMenuViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import PageMenu

class PageMenuViewController: UIViewController ,UIViewControllerTransitioningDelegate{

    var pageMenu : CAPSPageMenu?
    var group_id :Int?
    var postButton :UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pushToInvite"))

        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        let controller = OverViewController(nibName: "OverViewController", bundle: nil)
        controller.title = "Overview"
        controller.group_id = group_id
        controllerArray.append(controller)
        let controller2 = TimeLineViewController(nibName: "TimeLineViewController", bundle: nil)
        controller2.title = "Time Line"
        controller2.group_id = group_id
        controller2.delegate = self
        controllerArray.append(controller2)

        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .ViewBackgroundColor(UIColor(white: 1.0, alpha: 1.0)),
            .ScrollMenuBackgroundColor(yoshinaniColor())
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
       
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)        
    }
    
    func pushToInvite() {
        let pc = InviteFriendViewController(nibName :"InviteFriendViewController",bundle: nil)
        pc.group_id = group_id
        self.navigationController?.pushViewController(pc , animated: true)
    }
}

extension PageMenuViewController :TimeLineViewControllerDelegate {
    func pushNextViewControler(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

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
        
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        customButton.addTarget(self, action: Selector("pushToInvite"), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "Add"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.rightBarButtonItem = customButtonItem

        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []

        let controller = OverViewController(nibName: "OverViewController", bundle: nil)
        controller.title = "メンバー"
        controller.group_id = group_id
        controllerArray.append(controller)
        let controller2 = TimeLineViewController(nibName: "TimeLineViewController", bundle: nil)
        controller2.title = "ログ"
        controller2.group_id = group_id
        controller2.delegate = self
        controllerArray.append(controller2)

        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0),
            .ScrollMenuBackgroundColor(UIColor.mainColor()),
            .SelectionIndicatorColor(UIColor.accentColor())
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
       
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.addChildViewController(pageMenu!)
        
        pageMenu!.view.frame = self.view.bounds // modify this line as you like
        pageMenu!.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight] // modify this line as you like
        
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMoveToParentViewController(self)
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

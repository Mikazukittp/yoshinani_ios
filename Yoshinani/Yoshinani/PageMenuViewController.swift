//
//  PageMenuViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import PageMenu

protocol PageMenuIndicatorDelegate {
    func startChildViewIndicator()
    func stopChildViewIndicator()
}

class PageMenuViewController: BaseViewController ,UIViewControllerTransitioningDelegate{

    var pageMenu : CAPSPageMenu?
    var group_id :Int?
    var postButton :UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        customButton.addTarget(self, action: #selector(PageMenuViewController.pushToInvite), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "Add"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.rightBarButtonItem = customButtonItem
        setUpParts()
    }
    
    private func setUpParts() {
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        let overViewController = OverViewController(nibName: "OverViewController", bundle: nil)
        overViewController.title = "メンバー"
        overViewController.group_id = group_id
        overViewController.indicatorDelegate = self
        
        controllerArray.append(overViewController)
        let timeLineViewController = TimeLineViewController(nibName: "TimeLineViewController", bundle: nil)
        timeLineViewController.title = "ログ"
        timeLineViewController.group_id = group_id
        timeLineViewController.delegate = self
        timeLineViewController.indicatorDelegate = self
        controllerArray.append(timeLineViewController)
        
        
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

extension PageMenuViewController :PostBillPageMenuDelegate {
    func succeededPostBill() {
        setUpParts()
        //FIXME
        //pageMenu?.moveToPage(1)
    }
}

extension PageMenuViewController :TimeLineViewControllerDelegate {
    func pushNextViewControler(vc: PayerListViewController) {
        vc.postBillDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func presentNextViewController(vc: PostPageMenuViewController) {
        vc.postBillDelegate = self
        let nc = MenuNavigationController(rootViewController: vc)
        self.presentViewController(nc, animated: true) { () -> Void in
            
        }
    }
}

extension PageMenuViewController :PageMenuIndicatorDelegate {
    func startChildViewIndicator() {
        startIndicator()
    }
    
    func stopChildViewIndicator() {
        stopIndicator()
    }    
}

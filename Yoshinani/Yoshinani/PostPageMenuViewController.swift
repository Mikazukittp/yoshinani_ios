//
//  PostPageMenuViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/03.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import PageMenu

protocol PostBillPageMenuDelegate {
    func succeededPostBill()
}

class PostPageMenuViewController: BaseViewController ,UIViewControllerTransitioningDelegate{
    var pageMenu : CAPSPageMenu?
    var users :[User]?
    var group_id :Int?
    var postBillDelegate :PostBillPageMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        self.title = "入力フォーム"
        
        let controller = PostBillViewController(nibName: "PostBillViewController", bundle: nil)
        controller.title = "立替"
        controller.users = users
        controller.group_id = group_id
        controller.indicatorDelegate = self
        controller.postDelegate = self
        controllerArray.append(controller)
        
        let controller2 = RepaymentViewController(nibName: "RepaymentViewController", bundle: nil)
        controller2.title = "返済"
        controller2.users = users
        controller2.group_id = group_id
        controller2.indicatorDelegate = self
        controller2.postDelegate = self
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
        
        setCloseButton()
    }
    
    func setCloseButton() {
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        customButton.addTarget(self, action: #selector(PostPageMenuViewController.closeView), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
}

extension PostPageMenuViewController :PostBillDelagate {
    func succeededPostBill() {
        postBillDelegate?.succeededPostBill()
    }
}

extension PostPageMenuViewController :PageMenuIndicatorDelegate {
    func startChildViewIndicator() {
        startIndicator()
    }
    
    func stopChildViewIndicator() {
        stopIndicator()
    }    
}


//
//  BaseViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Firebase
import MRProgress

class BaseViewController: UIViewController {
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView

    let fireBase = Firebase(url:"https://yoshinani.firebaseio.com/status")
    
    var screenTitle :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingIndicator)
               
        fireBase.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            let isActive = snapshot.value.objectForKey("active") as! Bool
            
            if isActive == false {
                let title = snapshot.value.objectForKey("title") as! String
                let meesage = snapshot.value.objectForKey("message") as! String
                self.setMaintenanceAlertView(meesage, title: title)
            }
            }, withCancelBlock: { error in
            print(error.description)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let notNilTitle = screenTitle else{
            return
        }
        self.sendGA(notNilTitle)
    }
    
    override func viewDidLayoutSubviews() {
        loadingIndicator.center = CGPointMake(CGFloat(UIScreenUtil.screenWidth() / 2), CGFloat(UIScreenUtil.screenHeight() / 2))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    
    func startIndicator() {
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController!.view,title:"Loading...",mode:.Indeterminate, animated: true);
    }
    
    func stopIndicator() {
        MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true)
        loadingIndicator.stopAnimating()
    }
    
    func sendGA(name :String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
//    func setRetryButton() {
//        let retryButton = UIButton(frame: CGRectMake(CGFloat(UIScreenUtil.screenWidth() / 2), CGFloat(UIScreenUtil.screenHeight() / 2), 100, 100))
//        
//        retryButton.titleLabel?.text = "再試行"
//        retryButton.titleLabel!.layer.cornerRadius = retryButton.frame.width / 2;
//        retryButton.titleLabel!.clipsToBounds = true;
//        retryButton.titleLabel!.layer.borderColor = UIColor.mainColor().CGColor
//        retryButton.titleLabel!.layer.borderWidth = 2
//
//        retryButton.addTarget(self, action: #selector(BaseViewController.didTappedRetryButton(_:)), forControlEvents: .TouchUpInside)
//        self.view.addSubview(retryButton)
//    }
//    
//    func didTappedRetryButton(sender: UIButton!){
//        retryButtonAction()
//    }
//    
//    func retryButtonAction() {
//       print("子でオーバライドして処理を書いてください")
//    }
    
    private func setMaintenanceAlertView (message :String, title :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        presentViewController(alertController, animated: true, completion: nil)
    }    
}

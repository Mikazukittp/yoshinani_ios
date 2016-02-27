//
//  BaseViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loadingIndicator)        
    }
    
    override func viewDidLayoutSubviews() {
        loadingIndicator.center = CGPointMake(CGFloat(UIScreenUtil.screenWidth() / 2), CGFloat(UIScreenUtil.screenHeight() / 2))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    }
    
    func startIndicator() {
        self.view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.startAnimating();
    }
    
    func stopIndicator() {
        loadingIndicator.stopAnimating()
    }
}

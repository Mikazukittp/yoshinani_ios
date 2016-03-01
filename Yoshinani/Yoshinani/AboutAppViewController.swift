//
//  AboutAppViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/29.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    let titles = ["利用規約","プライバシーポリシー","著作権情報"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "このアプリについて"
        
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.addTarget(self.navigationController, action: "showMenu", forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
    }
    
    
}

extension AboutAppViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier: String = "MenuTableViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MenuTableViewCell
        
        if (cell == nil) {
            cell = MenuTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = titles[indexPath.row]
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = TermsOfServiceViewController(nibName: "TermsOfServiceViewController", bundle:nil)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {
            let vc = PrivacyPolicyViewController(nibName: "PrivacyPolicyViewController", bundle:nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = CopyRightViewController(nibName: "CopyRightViewController", bundle:nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

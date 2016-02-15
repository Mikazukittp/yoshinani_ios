//
//  MenuTableViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/27.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(indexPath:NSIndexPath)
}

class MenuTableViewController: UITableViewController {
    
    var tableData : Array<String> = []
    let titles = [["Home","Profile"],["About App","Copy Right","Sign Out"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cellの登録
        let nib  = UINib(nibName: "MenuTableViewCell", bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:"MenuTableViewCell")
        
        self.tableView.separatorColor = UIColor(red: 150/255.0, green: 161/255.0, blue: 177/255.0, alpha: 1.0)
        self.tableView.opaque = false
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles[section].count
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let frame = CGRectMake(0, 0, tableView.frame.size.width, 34)
        let view = UIView(frame: frame)
        
        view.backgroundColor = UIColor(red: 167/255.0, green: 167/255.0, blue: 167/255.0, alpha: 0.6)
        
        let label = UILabel(frame: CGRectMake(10,8,0,0))
        label.text = "Other";
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        view.addSubview(label)
        return view;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0 {
            return 0
        }
    
        return 34
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "MenuTableViewCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? MenuTableViewCell
        
        if (cell == nil) {
            cell = MenuTableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.text = titles[indexPath.section][indexPath.row]
        return cell!;
    }
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor(red: 62/255.0, green: 68/255.0, blue: 75/255.0, alpha: 1.0)
        cell.textLabel!.font = UIFont(name: "HelveticaNeue", size: 17)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if  indexPath.section == 0 && indexPath.row == 0 {
            let topVC = TopViewController(nibName: "TopViewController", bundle:nil)
            let MenuNC = MenuNavigationController(rootViewController: topVC)
            self.frostedViewController.contentViewController = MenuNC
            
        }else if indexPath.section == 0 && indexPath.row == 1 {
            //let vc: UIViewController = NewUserViewController(nibName: "NewUserViewController", bundle:nil)
            let profVC = ProfileViewController(nibName: "ProfileViewController" ,bundle: nil)
            let MenuNC = MenuNavigationController(rootViewController: profVC)
            //MenuNC.addChildViewController(profVC)
            self.frostedViewController.contentViewController = MenuNC
        }else if indexPath.section == 1 && indexPath.row == 2 {
            RealmManager.sharedInstance.deleteUserInfo()
            self.popToNewUserController()
        }
        
        self.frostedViewController.hideMenuViewController()
    }
}
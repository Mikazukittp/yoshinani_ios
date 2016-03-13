//
//  MenuTableViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/27.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var tableData : Array<String> = []
    let titles = [["icon"],["ホーム"],["プロフィール","このアプリについて","サインアウト"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cellの登録
        self.tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle:nil), forCellReuseIdentifier:"MenuTableViewCell")
        self.tableView.registerNib(UINib(nibName: "MenuProfTableViewCell", bundle:nil), forCellReuseIdentifier:"MenuProfTableViewCell")
        
        self.tableView.separatorColor = UIColor(red: 150/255.0, green: 161/255.0, blue: 177/255.0, alpha: 1.0)
        self.tableView.opaque = false
        self.tableView.backgroundColor = UIColor.clearColor()
        
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titles[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuProfTableViewCell") as? MenuProfTableViewCell
            let user = RealmManager.sharedInstance.userInfo
            cell?.setLabels(user!)
            return cell!
        }
        
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if  indexPath.section == 1 && indexPath.row == 0 {
            let topVC = TopViewController(nibName: "TopViewController", bundle:nil)
            let MenuNC = MenuNavigationController(rootViewController: topVC)
            self.frostedViewController.contentViewController = MenuNC
            
        }else if indexPath.section == 1 && indexPath.row == 1 {
            let profVC = ProfileViewController(nibName: "ProfileViewController" ,bundle: nil)
            let MenuNC = MenuNavigationController(rootViewController: profVC)
            self.frostedViewController.contentViewController = MenuNC
        }else if indexPath.section == 2 && indexPath.row == 0 {
            let profVC = ProfileViewController(nibName: "ProfileViewController" ,bundle: nil)
            let MenuNC = MenuNavigationController(rootViewController: profVC)
            self.frostedViewController.contentViewController = MenuNC
        }
        else if indexPath.section == 2 && indexPath.row == 1 {
            let copyVC = AboutAppViewController(nibName: "AboutAppViewController" ,bundle: nil)
            let MenuNC = MenuNavigationController(rootViewController: copyVC)
            self.frostedViewController.contentViewController = MenuNC
        }else if indexPath.section == 2 && indexPath.row == 2 {
            self.popToNewUserController()
        }
        
        self.frostedViewController.hideMenuViewController()
    }
}
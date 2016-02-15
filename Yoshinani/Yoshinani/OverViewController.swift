//
//  OverViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/13.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class OverViewController: UIViewController {

    
    var users :[User]?
    var group_id :Int?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let notNilUser =  RealmManager.sharedInstance.userInfo else{
            self.popToNewUserController()
            return
        }
        
        let uid = notNilUser.userId
        let token = notNilUser.token

        let groupSession = GroupSession()
        groupSession.users(uid, token: token, group_id: group_id!, complition: { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if error {
                    return
                }
                self.users = groupSession.group?.activeUsers
                print(self.users)
                self.tableView.reloadData()
            })
        })
        
        
        let nib = UINib(nibName: "OverviewTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "OverviewTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
}
extension OverViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notNilUsers = users else {
            return 0
        }
        return (notNilUsers.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = users![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewTableViewCell", forIndexPath: indexPath) as! OverviewTableViewCell
        let total = user.totals?.filter{$0.group_id == self.group_id}
        if total?.count == 0 {
            cell.setLabels(user.userName, total: nil)
            return cell
        }
        cell.setLabels(user.userName, total: total![0])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

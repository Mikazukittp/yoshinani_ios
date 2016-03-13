//
//  InviteViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class InvitedViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groups :[Group]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "招待中のグループ"
        self.screenTitle = "招待中画面(iOS)"
        
        let nib = UINib(nibName: "InviteCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "InviteCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.reloadData()
    }
}

extension InvitedViewController :UITableViewDelegate,UITableViewDataSource {
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups?.count == nil {
            return 0
        }
        return (groups?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InviteCell", forIndexPath: indexPath) as! InviteCell
        
        guard let notNilGroups = groups else {
            return cell
        }
        
        let group :Group? = notNilGroups[indexPath.row]
        guard let notNilGroup = group else {
            return cell
        }
        cell.setUp(notNilGroup)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let group = groups![indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        
        guard let nonNilUser = user else{
            self.popToNewUserController()
            return
        }
        setAlertView(group.name, group_id: group.group_id, user: nonNilUser)
    }
    
    private func setAlertView (title :String, group_id :Int, user:RUser) {
        let alertController = UIAlertController(title: title, message: "グループに参加しますか？", preferredStyle: .Alert)
        
        let session = GroupSession()
        
        let defaultAction = UIAlertAction(title: "はい", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            session.accept(user.userId, token: user.token, group_id: group_id, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    switch error {
                    case .NetworkError:
                        self.caution(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        self.navigationController?.popViewControllerAnimated(true)
                        break
                    case .ServerError:
                        self.caution(ServerErrorTitle, message: ServerErrorMessage)
                        break
                    case .UnauthorizedError:
                        self.popToNewUserController()
                        break
                    }
                 })
            })
        })
        
        let destroyAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: {
            (action:UIAlertAction!) -> Void in
            session.destroy(user.userId, token: user.token, group_id: group_id, user_id: user.userId, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    switch error {
                    case .NetworkError:
                        self.caution(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        self.navigationController?.popViewControllerAnimated(true)
                        break
                    case .ServerError:
                        self.caution(ServerErrorTitle, message: ServerErrorMessage)
                        break
                    case .UnauthorizedError:
                        self.popToNewUserController()
                        break
                    }
                })
            })
        })
        
        alertController.addAction(defaultAction)
        alertController.addAction(destroyAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func caution (title: String, message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
        alertController.addAction(defaultAction)

    }
}

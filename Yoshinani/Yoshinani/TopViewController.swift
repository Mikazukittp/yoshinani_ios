//
//  TopViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/24.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift
import Unbox

class TopViewController: UIViewController  ,UITableViewDataSource ,UITableViewDelegate  {
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sumPay: UILabel!
    var user :User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //登録画面に戻らせないため
        self.navigationItem.hidesBackButton = true
        self.edgesForExtendedLayout = .None
        
        self.title = "参加グループ"        
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.addTarget(self.navigationController, action: Selector("showMenu"), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
        
        
        let customButtonRight :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        customButtonRight.addTarget(self, action: Selector("pushToInvite"), forControlEvents: .TouchUpInside)
        customButtonRight.setBackgroundImage(UIImage(named: "Add"), forState: UIControlState.Normal)
        let customButtonItemRight :UIBarButtonItem = UIBarButtonItem(customView: customButtonRight)
        self.navigationItem.rightBarButtonItem = customButtonItemRight
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "GroupTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        
        if let nonNilUser = user {
            let session = UserSession()
            session.show(nonNilUser.userId, token: nonNilUser.token, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if !error {
                        self.user = session.user
                        self.sumPay.text = "¥\(session.user?.sumPay ?? 0)"
                        self.tableView.reloadData()
                    }else {
                        self.popToNewUserController()
                    }
                })
            })
            
        }else {
            //ユーザ情報がないので強制的にTOPに戻す
            self.popToNewUserController()
        }
    }
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        let vc = CreateRoomViewController(nibName: "CreateRoomViewController", bundle: nil)
        vc.modalPresentationStyle = .Custom
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(vc, animated: true) { () -> Void in
    
        }
    }
    
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notNilGroups = user?.activeGroups else {
            return 0
        }
        
        return notNilGroups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupTableViewCell", forIndexPath: indexPath) as! GroupTableViewCell
 
        guard let notNilGroups = user?.activeGroups else {
            return cell
        }
    
        let group = notNilGroups[indexPath.row]
        if indexPath.row < user?.totals?.count {
            cell.setLabels(group, total: user?.totals?[indexPath.row])
        }else{
            cell.setLabels(group, total: nil)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let notNilGroups = user?.activeGroups else {
            return
        }
        
        let pc = PageMenuViewController()
        pc.group_id = notNilGroups[indexPath.row].group_id
        pc.title = notNilGroups[indexPath.row].name
        self.navigationController?.pushViewController(pc, animated: true)

    }
    
    func pushToInvite() {
        let pc = InvitedViewController(nibName :"InvitedViewController",bundle: nil)
        pc.groups = self.user?.invitedGroups
        self.navigationController?.pushViewController(pc , animated: true)
    }
}

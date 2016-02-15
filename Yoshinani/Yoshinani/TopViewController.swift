//
//  TopViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/24.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import BubbleTransition
import RealmSwift
import Unbox

class TopViewController: UIViewController ,UIViewControllerTransitioningDelegate ,UITableViewDataSource ,UITableViewDelegate  {
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    let transition = BubbleTransition()
    var user :User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //登録画面に戻らせないため
        self.navigationItem.hidesBackButton = true
        
        self.title = "Groups"        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self.navigationController, action:Selector("showMenu"))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("pushToInvite"))
        
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
        vc.view.frame = self.view.frame
        print(self.view.frame)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .Custom
        self.presentViewController(vc, animated: true) { () -> Void in
    
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.startingPoint = createButton.center
        transition.bubbleColor = createButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.startingPoint = createButton.center
        transition.bubbleColor = createButton.backgroundColor!
        return transition
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
         cell.textLabel?.text = group.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let notNilGroups = user?.activeGroups else {
            return
        }
        
        let pc = PageMenuViewController()
        pc.group_id = notNilGroups[indexPath.row].group_id
        self.navigationController?.pushViewController(pc, animated: true)

    }
    
    func pushToInvite() {
        let pc = InvitedViewController(nibName :"InvitedViewController",bundle: nil)
        pc.groups = self.user?.invitedGroups
        self.navigationController?.pushViewController(pc , animated: true)
    }
}

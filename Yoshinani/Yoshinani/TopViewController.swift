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
import GoogleMobileAds


class TopViewController: BaseViewController  ,UITableViewDataSource ,UITableViewDelegate  {
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sumPay: UILabel!
    @IBOutlet weak var admobView: GADBannerView!
    
    var onSession = false
    
    var user :User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //登録画面に戻らせないため
        self.navigationItem.hidesBackButton = true
        self.edgesForExtendedLayout = .None
        
        self.title = "参加グループ"
        self.screenTitle = "トップ画面(iOS)"
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 35, 35))
        customButton.addTarget(self.navigationController, action: Selector("showMenu"), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "List"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
        
        let nib = UINib(nibName: "GroupTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "GroupTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        setAdBannerView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.startIndicator()
        reloadData()
    }
    
    private func setAdBannerView(){
        self.admobView.adUnitID = Const.urlAdmob;
        self.admobView.rootViewController = self;
        self.admobView.loadRequest(GADRequest())
    }
    
    private func reloadData() {
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        print("connect")
        if let nonNilUser = user {
            let session = UserSession()
            session.show(nonNilUser.userId, token: nonNilUser.token, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()
                    self.onSession = false
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        self.user = session.user
                        let pay = session.user?.sumPay ?? 0
                        let payWithComma = StringUtil.cordinateStringWithComma(pay)
                        self.sumPay.text = "¥\(payWithComma)"
                        
                        if pay < 0 {
                            self.sumPay.textColor = UIColor.accentColor()
                        }else {
                            self.sumPay.textColor = UIColor.thirdColor()
                        }
                        
                        self.setInvitedButton()
                        self.tableView.reloadData()
                        break
                    case .ServerError:
                        self.setAlertView(ServerErrorMessage, message: ServerErrorMessage)
                        break
                    case .UnauthorizedError:
                        self.popToNewUserController()
                        break
                    }

                })
            })
            
        }else {
            self.stopIndicator()
            //ユーザ情報がないので強制的にTOPに戻す
            self.popToNewUserController()
        }

    }
    
    private func setInvitedButton() {
        if user?.invitedGroups?.count > 0 {
            let customButtonRight :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
            customButtonRight.addTarget(self, action: Selector("pushToInvite"), forControlEvents: .TouchUpInside)
            customButtonRight.setBackgroundImage(UIImage(named: "Invited"), forState: UIControlState.Normal)
            let customButtonItemRight :UIBarButtonItem = UIBarButtonItem(customView: customButtonRight)
            self.navigationItem.rightBarButtonItem = customButtonItemRight
        }
    }
    
   private func setAlertView (title :String ,message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
        })
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
        
    @IBAction func createButtonTapped(sender: AnyObject) {
        let vc = CreateRoomViewController(nibName: "CreateRoomViewController", bundle: nil)
        let nc = UINavigationController(rootViewController: vc)
        vc.modalPresentationStyle = .Custom
        vc.modalTransitionStyle = .CrossDissolve
        self.presentViewController(nc, animated: true) { () -> Void in
    
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
        
        let total = user?.totals?.filter { $0.group_id == group.group_id}
        
        if total?.count > 0 {
            cell.setLabels(group, total: total![0])
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


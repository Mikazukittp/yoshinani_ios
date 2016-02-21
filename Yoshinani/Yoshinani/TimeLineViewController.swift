//
//  TimeLineViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import BubbleTransition

protocol TimeLineViewControllerDelegate {
    func pushNextViewControler (vc :UIViewController)
}

class TimeLineViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!

    let transition = BubbleTransition()
    var payments :[Payment]?
    var users :[User]?
    var group_id :Int?
    var delegate :TimeLineViewControllerDelegate?
    var onSession = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: "BillTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "BillTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        guard let notNilUser =  RealmManager.sharedInstance.userInfo else{
            self.popToNewUserController()
            return
        }
        
        let uid = notNilUser.userId
        let token = notNilUser.token

        let session = PaymentSession()
        session.payments(uid, pass: token, group_id: group_id!,last_id: nil) { (error) -> Void in
            
            if error {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.setAlertView()
                })
                return
            }
            self.payments = session.payments
            
            let groupSession = GroupSession()
            groupSession.users(uid, token: token, group_id: self.group_id!, complition: { (groupSessionError) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if groupSessionError {
                        self.setAlertView()
                        return
                    }
                    
                    self.users = groupSession.group?.activeUsers
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    //MARK: IBAction
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        let vc = PostBillViewController(nibName: "PostBillViewController", bundle: nil)
        vc.modalPresentationStyle = .Custom
        vc.modalTransitionStyle = .CrossDissolve
        vc.users = users
        vc.group_id = group_id
        self.presentViewController(vc, animated: true) { () -> Void in
        
        }
    }
    
    //MARK: Private 
    
    func setAlertView () {
        let alertController = UIAlertController(title: "通信エラー", message: "通信環境の良い場所で通信してください", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
            //ユーザ情報がないので強制的にTOPに戻す
            self.popToNewUserController()
        })

        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension TimeLineViewController :UITableViewDelegate ,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if payments?.count == nil {
            return 0
        }
        
        return (payments?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BillTableViewCell", forIndexPath: indexPath) as! BillTableViewCell
        
        guard let notNilPayments = payments else {
            return cell
        }
        
        let pay :Payment? = notNilPayments[indexPath.row]
        cell.setUpParts(pay!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let payment = payments![indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let pc = PayerListViewController(nibName: "PayerListViewController", bundle: nil)
        pc.payerList = payment.participants
        
        delegate?.pushNextViewControler(pc)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
       
        if onSession { return }
        
        guard let notNilPayments = payments else {
            return
        }
        
        if indexPath.row == (notNilPayments.count - 1){
            let session = PaymentSession()
            
            guard let notNilUser =  RealmManager.sharedInstance.userInfo else{
                self.popToNewUserController()
                return
            }
            
            let uid = notNilUser.userId
            let token = notNilUser.token
            
            self.onSession = true
            session.payments(uid, pass: token, group_id: group_id!,last_id: notNilPayments.last?.payment_id) { (error) -> Void in

                self.onSession = false
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error {
                        self.setAlertView()
                        return
                    }
                    
                    guard let newPayments = session.payments else {
                        self.onSession = true
                        return
                    }
                    if newPayments.count == 0 {
                        self.onSession = true
                        return
                    }
                    
                    self.payments?.appendContentsOf(newPayments)
                    self.tableView.reloadData()
                })
            }
        }
    }
}
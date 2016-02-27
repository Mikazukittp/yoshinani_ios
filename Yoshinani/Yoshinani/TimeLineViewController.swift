//
//  TimeLineViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

protocol TimeLineViewControllerDelegate {
    func pushNextViewControler (vc :UIViewController)
}

class TimeLineViewController: BaseViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!

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
        reloadData()
    }
    
    private func reloadData() {
        if onSession { return }
        onSession = true
        guard let notNilUser =  RealmManager.sharedInstance.userInfo else{
            self.popToNewUserController()
            return
        }
        
        let uid = notNilUser.userId
        let token = notNilUser.token
        
        let session = PaymentSession()
        self.startIndicator()
        session.payments(uid, pass: token, group_id: group_id!,last_id: nil) { (error) -> Void in
            
            switch error {
            case .NetworkError:
                self.stopIndicator()
                self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                self.onSession = false
                return
            case .Success:
                self.payments = session.payments
                
                let groupSession = GroupSession()
                groupSession.users(uid, token: token, group_id: self.group_id!, complition: { (groupSessionError) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.stopIndicator()
                        self.onSession = false
                        
                        switch groupSessionError {
                        case .NetworkError:
                            self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                            break
                        case .Success:
                            self.users = groupSession.group?.activeUsers
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
                break
            case .ServerError:
                self.stopIndicator()
                self.setAlertView(ServerErrorMessage, message: ServerErrorMessage)
                self.onSession = false
                return
            case .UnauthorizedError:
                self.popToNewUserController()
                return
            }
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
    
    func setAlertView (title :String ,message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
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
        pc.payer = payment.paid_user
        pc.payment_id = payment.payment_id
        
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
            
            self.startIndicator()
            session.payments(uid, pass: token, group_id: group_id!,last_id: notNilPayments.last?.payment_id) { (error) -> Void in

                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()
                    self.onSession = false
                    
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        guard let newPayments = session.payments else {
                            return
                        }
                        if newPayments.count == 0 {
                            return
                        }
                        
                        self.payments?.appendContentsOf(newPayments)
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
            }
        }
    }
    /*
    スクロール時
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // 下に引っ張ったときは、ヘッダー位置を計算して動かないようにする（★ここがポイント..）
        if scrollView.contentOffset.y < 0 {
            reloadData()
        }
    }

}

//
//  TimeLineViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

protocol TimeLineViewControllerDelegate {
    func pushNextViewControler (vc :PayerListViewController)
    func presentNextViewController(vc :PostPageMenuViewController)
}

class TimeLineViewController: BaseViewController{

    
    enum TimeLineListType :Int{
        case Payment
        case LoadMore
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!

    var payments :[Payment]?
    var users :[User]?
    var group_id :Int?
    var delegate :TimeLineViewControllerDelegate?
    var indicatorDelegate :PageMenuIndicatorDelegate?
    var onSession = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.screenTitle = "全ログ画面(iOS)"
        
        tableView?.registerNib(UINib(nibName: "BillTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "BillTableViewCell")
        tableView?.registerNib(UINib(nibName: LoadMoreTableViewCell.identifier, bundle: nil),
                               forCellReuseIdentifier: LoadMoreTableViewCell.identifier)
        
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        indicatorDelegate?.startChildViewIndicator()
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
        session.payments(uid, pass: token, group_id: group_id!,last_id: nil) { (error) -> Void in
            
            switch error {
            case .NetworkError:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicatorDelegate?.stopChildViewIndicator()
                    self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                    self.onSession = false
                    })
                return
            case .Success:
                self.payments = session.payments
                let groupSession = GroupSession()
                groupSession.users(uid, token: token, group_id: self.group_id!, complition: { (groupSessionError) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.indicatorDelegate?.stopChildViewIndicator()
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
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicatorDelegate?.stopChildViewIndicator()
                    self.setAlertView(ServerErrorMessage, message: ServerErrorMessage)
                    self.onSession = false
                    })
                return
            case .UnauthorizedError:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicatorDelegate?.stopChildViewIndicator()
                    self.popToNewUserController()
                    })
                return
            }
         }

    }
    
    //MARK: IBAction
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        let vc = PostPageMenuViewController()
        vc.modalPresentationStyle = .Custom
        vc.modalTransitionStyle = .CrossDissolve
        vc.users = users
        vc.group_id = group_id
        delegate?.presentNextViewController(vc)
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
//    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //イベント＋さらによみこむ
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case TimeLineListType.Payment.rawValue:
            
            if payments?.count == nil {
                return 0
            }
            return (payments?.count)!
            
        case TimeLineListType.LoadMore.rawValue:
            if payments?.count == nil {
                return 0
            }
            return 1
        default:
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case TimeLineListType.Payment.rawValue:
            return paymentCell(indexPath)
        case TimeLineListType.LoadMore.rawValue:
            return loadMoreCell(indexPath)
        default :
            return loadMoreCell(indexPath)
        }
    }
    
    private func paymentCell(indexPath :NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BillTableViewCell", forIndexPath: indexPath) as! BillTableViewCell
        
        guard let notNilPayments = payments else {
            return cell
        }
        
        let pay :Payment? = notNilPayments[indexPath.row]
        cell.setUpParts(pay!)
        return cell
    }
    
    private func loadMoreCell(indexPath :NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LoadMoreTableViewCell.identifier, forIndexPath: indexPath) as! LoadMoreTableViewCell
        cell.disableReloadButton()
        cell.startIndicator()
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == TimeLineListType.LoadMore.rawValue {
            addSession()
            loadMoreCell(indexPath)
            return
        }
        
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
        
        if indexPath.section == TimeLineListType.LoadMore.rawValue {
            addSession()
        }
    }
    private func addSession() {
        
        guard let notNilPayments = payments else {
            return
        }
        
        guard let notNilUser =  RealmManager.sharedInstance.userInfo else{
            self.popToNewUserController()
            return
        }
        let session = PaymentSession()
        let uid = notNilUser.userId
        let token = notNilUser.token
        self.onSession = true
        session.payments(uid, pass: token, group_id: group_id!,last_id: notNilPayments.last?.payment_id) { (error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.onSession = false
                
                self.tableView.visibleCells.forEach{
                    if $0.reuseIdentifier == LoadMoreTableViewCell.identifier {
                        let cell =  $0 as! LoadMoreTableViewCell
                        cell.stopIndicator()
                        if error != .Success {
                            cell.enableReloadButton()
                        }
                    }
                }
                
                switch error {
                case .NetworkError: break
                case .ServerError: break
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
                case .UnauthorizedError:
                    self.popToNewUserController()
                    break
                }
            })
        }
    }
}
//
//  PayerListViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class PayerListViewController: BaseViewController ,UITableViewDataSource, UITableViewDelegate{

    var payerList :[User]?
    var payer :User?
    var payment_id :Int?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "参加者"
        self.screenTitle = "支払い者リスト画面(iOS)"
        
        let nib = UINib(nibName: "PayerListTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PayerListTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        let user = RealmManager.sharedInstance.userInfo

        if user?.userId == payer?.userId {
            let customButtonRight :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
            customButtonRight.addTarget(self, action: Selector("deletePost"), forControlEvents: .TouchUpInside)
            customButtonRight.setBackgroundImage(UIImage(named: "Delete"), forState: UIControlState.Normal)
            let customButtonItemRight :UIBarButtonItem = UIBarButtonItem(customView: customButtonRight)
            self.navigationItem.rightBarButtonItem = customButtonItemRight
        }
        
    }
    
    func deletePost () {
        let alertController = UIAlertController(title: "投稿削除", message: "投稿を削除しますか？", preferredStyle: .Alert)
        let session = PaymentSession()
        
        let user = RealmManager.sharedInstance.userInfo

        
        let defaultAction = UIAlertAction(title: "はい", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
        
            self.startIndicator()
            session.delete(user!.userId, pass: user!.token, payment_id: self.payment_id!, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        self.navigationController?.popViewControllerAnimated(true)
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
        })
        
        let destroyAction = UIAlertAction(title: "いいえ", style: .Cancel, handler: {
            (action:UIAlertAction!) -> Void in
        })
        
        alertController.addAction(defaultAction)
        alertController.addAction(destroyAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func setAlertView (title :String, message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
        alertController.addAction(defaultAction)
        
    }


    
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notNilPayerList = payerList else {
            return 0
        }
        return (notNilPayerList.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = payerList![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PayerListTableViewCell", forIndexPath: indexPath) as! PayerListTableViewCell
        cell.setName(user.userName ?? user.account)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)        
    }

    
}

//
//  RepaymentViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/03.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class RepaymentViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var eventInput: UITextField!
    
    var users :[User]?
    var selectIndex :Int?
    var group_id :Int?
    var indicatorDelegate :PageMenuIndicatorDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenTitle = "返済投稿画面(iOS)"
        
        priceInput.keyboardType = .NumberPad
        priceInput.returnKeyType = .Done
        priceInput.delegate = self
        
        eventInput.returnKeyType = .Done
        eventInput.delegate = self
        
        let nib = UINib(nibName: "ToPayUserCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "ToPayUserCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        let user :RUser? = RealmManager.sharedInstance.userInfo
        users = users?.filter{$0.account != user?.account}
        
        tableView.reloadData()
     }
    
    @IBAction func didTapSubmitButton(sender: AnyObject) {
        let textFields = [priceInput,eventInput]
        let isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
        
        if priceInput.markedTextRange != nil {
            return
        }
        
        if eventInput.markedTextRange != nil {
            
        }
        
        guard let notNilUser = RealmManager.sharedInstance.userInfo else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        guard let notNilUsers = users else {
            return
        }
        
        guard let notNIlIndex = selectIndex else {
            self.setAlertView("項目エラー", alert: "ユーザを選択してください")
            return
        }

        let participants = [notNilUsers[notNIlIndex].userId]
        
        let user = User(token: "", userId: notNilUser.userId, userName: "", email: "")
        let price = priceInput.text! as String
        
        let userName = notNilUsers[notNIlIndex].userName ?? notNilUsers[notNIlIndex].account
        
        let payment = Payment(amount:Int(price)!, event: eventInput.text!, description: "\(userName)への返済", created_at: nowDateString(), paid_user: user)
        
        self.indicatorDelegate?.startChildViewIndicator()
        if isSuccess {
            let session = PaymentSession()
            session.create(notNilUser.userId, pass: notNilUser.token, payment: payment, group_id: group_id!, participants: participants, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicatorDelegate?.stopChildViewIndicator()
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, alert: NetworkErrorMessage)
                        break
                    case .Success:
                        self.dismissViewControllerAnimated(true, completion: nil)
                        break
                    case .ServerError:
                        self.setAlertView(ServerErrorMessage, alert: RequestErrorMessage)
                        break
                    case .UnauthorizedError:
                        self.popToNewUserController()
                        break
                    }
                })
            })
        }
    }
    
    private func nowDateString() -> String{
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString: String = dateFormatter.stringFromDate(date)
        return dateString
    }
    
    private func nilCheck(textFields :[UITextField!] , alertMessage: String) -> Bool{
        
        var isSuccess = true
        
        textFields.forEach {
            if $0.text!.isEmpty {
                $0.attributedPlaceholder = NSAttributedString(string:alertMessage,
                    attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
                
                isSuccess = false
            }
            
            if $0.markedTextRange != nil {
                isSuccess = false
            }
        }
        return isSuccess
    }
    
    func setAlertView (title :String, alert :String) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}
extension RepaymentViewController: UITextFieldDelegate{
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension RepaymentViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if users?.count == nil {
            return 0
        }
        
        return (users?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ToPayUserCell", forIndexPath: indexPath) as! ToPayUserCell
        guard let notNilUsers = users else {
            return cell
    }
        
        let user :User = notNilUsers[indexPath.row]
        
        var isBlank = true
        if selectIndex == indexPath.row {
            isBlank = false
        }
        
        cell.setProperties(user.userName ?? user.account, check:isBlank)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectIndex = indexPath.row
        tableView.reloadData()
    }
}


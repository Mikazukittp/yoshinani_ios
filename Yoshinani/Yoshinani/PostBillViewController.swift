//
//  PostBillViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

protocol PostBillDelagate {
    func succeededPostBill()
}

class PostBillViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var users :[User]? {
        didSet {
            guard let notNilUsers = users else {
                return
            }
            notNilUsers.forEach{ _ in  checkList.append(false) }
        }
    }
    var checkList :[Bool] = []
    
    var datePicker: UIDatePicker!
    var toolBar:UIToolbar!
    var group_id :Int?
    var indicatorDelegate :PageMenuIndicatorDelegate?
    var postDelegate :PostBillDelagate?
    
    @IBOutlet weak var eventInput: UITextField!
    @IBOutlet weak var detailInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenTitle = "立替精算画面(iOS)"
        
        setTextInput()
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(PostBillViewController.changedDateEvent(_:)), forControlEvents: UIControlEvents.ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateInput.inputView = datePicker
        
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: #selector(PostBillViewController.didTapToolBarBtn(_:)))
        toolBarBtn.tag = 1

        toolBar.items = [toolBarBtn]
        dateInput.inputAccessoryView = toolBar
        
        //現在時刻設定
        changeLabelDate(NSDate())
       
        let nib = UINib(nibName: "ToPayUserCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "ToPayUserCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK :Action
    @IBAction func didTapDismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
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
        cell.setProperties(user.userName ?? user.account, check: !checkList[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let checked = checkList[indexPath.row]
        checkList[indexPath.row] = checked ? false :true        
        tableView.reloadData()
    }
    @IBAction func didTapSubmitButton(sender: AnyObject) {
        let textFields = [detailInput,dateInput,priceInput,eventInput]
        let isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
        
        if dateInput.markedTextRange != nil {
            return;
        }
        
        if priceInput.markedTextRange != nil {
            return
        }
        
        if detailInput.markedTextRange != nil {
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
        
        let participants = participants_ids(notNilUsers, checked: checkList)
     
        if participants.count == 0  {
            self.setAlertView("項目エラー", alert: "ユーザを選択してください")
            return
        }
        
        let user = User(token: "", userId: notNilUser.userId, userName: "", email: "")
        let price = priceInput.text! as String
        
        let payment = Payment(amount:Int(price)!, event: eventInput.text!, description: detailInput.text!, created_at: dateInput.text!, paid_user: user)
                
        if isSuccess {
            let session = PaymentSession()
            self.indicatorDelegate?.startChildViewIndicator()
            session.create(notNilUser.userId, pass: notNilUser.token, payment: payment, group_id: group_id!, participants: participants, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.indicatorDelegate?.stopChildViewIndicator()
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, alert: NetworkErrorMessage)
                        break
                    case .Success:
                        self.dismissViewControllerAnimated(true, completion: {
                            self.postDelegate?.succeededPostBill()
                         })
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
    
    private func setTextInput() {
        priceInput.keyboardType = .NumberPad
        priceInput.returnKeyType = .Done
        priceInput.delegate = self
        
        eventInput.returnKeyType = .Done
        eventInput.delegate = self
        
        detailInput.returnKeyType = .Done
        detailInput.delegate = self

    }
        
    private func nilCheck(textFields :[UITextField!] , alertMessage: String) -> Bool{
        
        var isSuccess = true
        
        textFields.forEach {
            if $0.text!.isEmptyField {
                $0.attributedPlaceholder = NSAttributedString(string:alertMessage,
                    attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
                $0.text = nil
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

extension PostBillViewController: UIToolbarDelegate, UITextFieldDelegate{

    func changedDateEvent(sender: UIDatePicker ){
        self.changeLabelDate(sender.date)
    }
    
    func changeLabelDate(date:NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString: String = dateFormatter.stringFromDate(date)
        
        dateInput.text = dateString
    }

    
    func didTapToolBarBtn(sender: UIBarButtonItem ) {
        dateInput.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}

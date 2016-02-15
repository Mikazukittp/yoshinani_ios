//
//  PostBillViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class PostBillViewController: UIViewController {

    @IBOutlet weak var dissmissButton: UIButton!
    
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
    
    @IBOutlet weak var detailInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dissmissButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        
        setTextInput()
        
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: "changedDateEvent:", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.datePickerMode = UIDatePickerMode.Date
        dateInput.inputView = datePicker
        
        toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .BlackTranslucent
        toolBar.tintColor = UIColor.whiteColor()
        toolBar.backgroundColor = UIColor.blackColor()
        
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .Plain, target: self, action: "didTapToolBarBtn:")
        toolBarBtn.tag = 1

        toolBar.items = [toolBarBtn]
        dateInput.inputAccessoryView = toolBar
       
        let nib = UINib(nibName: "PayerListTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PayerListTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: IBAction
    
    @IBAction func dismissButtonTapped(sender: AnyObject) {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("PayerListTableViewCell", forIndexPath: indexPath) as! PayerListTableViewCell        
        guard let notNilUsers = users else {
            return cell
        }
        
        let user :User? = notNilUsers[indexPath.row]
        cell.setName((user?.userName)!)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.dequeueReusableCellWithIdentifier("PayerListTableViewCell", forIndexPath: indexPath) as! PayerListTableViewCell
        let checked = checkList[indexPath.row]
        checkList[indexPath.row] = checked ? false :true
        
        print(checkList)

        cell.accessoryType = .Checkmark
    }
    @IBAction func didTapSubmitButton(sender: AnyObject) {
        let textFields = [detailInput,dateInput,priceInput]
        let isSuccess = self.nilCheck(textFields, alertMessage: "不正な入力値です")
        
        if dateInput.markedTextRange != nil {
            return;
        }
        
        if priceInput.markedTextRange != nil {
            return
        }
        
        if detailInput.markedTextRange != nil {
            return
        }
        
        guard let notNilUser = RealmManager.sharedInstance.userInfo else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        print(notNilUser)
        
        let participants = participants_ids(self.users!, checked: checkList)
     
        if participants.count == 0  {
            self.setAlertView("ユーザを選択してください")
            return
        }
        
        let user = User(token: "", userId: notNilUser.userId, userName: "", email: "")
        let price = priceInput.text! as String
        
        let payment = Payment(amount:Int(price)!, event: "", description: detailInput.text!, created_at: dateInput.text!, paid_user: user)
        
        print(payment)
        
        if isSuccess {
            let session = PaymentSession()
            session.create(notNilUser.userId, pass: notNilUser.token, payment: payment, group_id: group_id!, participants: participants, complition: { (error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if error {
                        self.setAlertView("通信環境の良い場所で通信してください。")
                    }else {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                })
            })
        }
    }
    
    private func setTextInput() {
        priceInput.keyboardType = .NumberPad
        priceInput.returnKeyType = .Done
        priceInput.delegate = self
        
        detailInput.returnKeyType = .Done
        detailInput.delegate = self

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
    
    func setAlertView (alert :String) {
        let alertController = UIAlertController(title: "エラー", message: alert, preferredStyle: .Alert)
        
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

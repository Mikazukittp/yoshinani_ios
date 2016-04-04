//
//  CreateRoomViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/24.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class CreateRoomViewController: BaseViewController,UITextFieldDelegate,InvitedFriendViewControllerDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var descriptionNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "グループ作成"
        self.screenTitle = "グループ作成画面(iOS)"
        self.edgesForExtendedLayout = .None

        groupNameTextField.delegate = self
        descriptionNameTextField.delegate = self
        
        groupNameTextField.returnKeyType = .Next
        descriptionNameTextField.returnKeyType = .Done
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)

        setCloseButton()
    }
    
    func setCloseButton() {
        let customButton :UIButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        customButton.addTarget(self, action: Selector("closeView"), forControlEvents: .TouchUpInside)
        customButton.setBackgroundImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
        let customButtonItem :UIBarButtonItem = UIBarButtonItem(customView: customButton)
        self.navigationItem.leftBarButtonItem = customButtonItem
    }
    
    func closeView() {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        let textFields = [groupNameTextField,descriptionNameTextField]
        let isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
        
        if groupNameTextField.markedTextRange != nil {
            return;
        }
        
        if descriptionNameTextField.markedTextRange != nil {
            return
        }
        
        guard let notNilUser = RealmManager.sharedInstance.userInfo else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if isSuccess {
            let session = GroupSession()
            self.startIndicator()
            session.create(notNilUser.userId, token: notNilUser.token, name: groupNameTextField.text!, desp: descriptionNameTextField.text!, complition: { (error, group_id) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                        break
                    case .Success:
                        let pc = InviteFriendViewController(nibName :"InviteFriendViewController",bundle: nil)
                        pc.group_id = group_id
                        pc.delegate = self
                        self.navigationController?.pushViewController(pc, animated: true)
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
        }
        
    }
    
    func didSuccessInvitationToUser() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func textFieldDidChange(notification:NSNotification){
        
        //ここで文字数を取得して、いい感じに処理します。
        let length = groupNameTextField.text?.utf16.count
        
        if length > 20 {
            groupNameTextField.text = ""
            groupNameTextField.attributedPlaceholder = NSAttributedString(string: "20文字を超えています。",attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //MARK: Private
    
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
    
    private func setAlertView (title :String ,message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:{
            (action:UIAlertAction!) -> Void in
        })
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}


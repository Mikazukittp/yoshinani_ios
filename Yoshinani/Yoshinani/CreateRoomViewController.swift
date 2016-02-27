//
//  CreateRoomViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/24.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var descriptionNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNameTextField.delegate = self
        descriptionNameTextField.delegate = self
        
        groupNameTextField.returnKeyType = .Next
        descriptionNameTextField.returnKeyType = .Done
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)

    }
    @IBAction func submitButtonTapped(sender: AnyObject) {
        let textFields = [groupNameTextField,descriptionNameTextField]
        let isSuccess = self.nilCheck(textFields, alertMessage: "不正な入力値です")
        
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
            session.create(notNilUser.userId, token: notNilUser.token, name: groupNameTextField.text!, desp: descriptionNameTextField.text!, complition: { (error) -> Void in
                switch error {
                case .NetworkError:
                    self.setAlertView(NetworkErrorTitle, message: NetworkErrorMessage)
                    break
                case .Success:
                    self.dismissViewControllerAnimated(true, completion: nil)
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


//
//  ChangePasswordViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/06.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController ,UITextFieldDelegate {

    @IBOutlet weak var currentPasswordInput: UITextField!
    @IBOutlet weak var newPasswordInput: UITextField!
    @IBOutlet weak var reNewPasswordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.title = "パスワード変更"
        self.screenTitle = "パスワード変更画面(iOS)"
        
        currentPasswordInput.keyboardType = .ASCIICapable
        newPasswordInput.keyboardType = .ASCIICapable
        reNewPasswordInput.keyboardType = .ASCIICapable
        
        currentPasswordInput.secureTextEntry = true
        newPasswordInput.secureTextEntry = true
        reNewPasswordInput.secureTextEntry = true

        currentPasswordInput.delegate = self
        newPasswordInput.delegate = self
        reNewPasswordInput.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)

    }
    
@IBAction func submitButtonTapped(sender: AnyObject) {
    
    let textFields = [currentPasswordInput,newPasswordInput,reNewPasswordInput]
    let isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
    
    if isSuccess {
        
        let currentPassword = currentPasswordInput.text!
        let password = newPasswordInput.text!
        let repassword = reNewPasswordInput.text!
        
        if password != repassword {
            setAlertView("パスワードが一致しません")
            return
        }
        
        
        let user = RealmManager.sharedInstance.userInfo
        guard let notNilUser = user else {
            popToNewUserController()
            return
        }
        
        let session = PasswordSession()
        let property = (currentPassword,password,repassword)
        
        self.startIndicator()
        
        session.change(notNilUser.userId, token: notNilUser.token, property: property, complition: { (error, user, message) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopIndicator()
                
                switch error {
                case .NetworkError:
                    self.setAlertView(NetworkErrorMessage)
                    break
                case .Success:
                    self.setAlertView(SuccessTitle, message: PasswordMessage, closure: { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                    break
                case .ServerError:
                    let alertMessage = message ?? ServerErrorMessage
                    self.setAlertView(alertMessage)
                    break
                case .UnauthorizedError:
                    self.setAlertView("通信失敗",message :ServerErrorMessage, closure: { () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.popToNewUserController()
                        })
                    })
                    break
                }
                
            })
        })
    }
}

    @IBAction func didTapChengeButton(sender: AnyObject) {

    }

    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //MARK* Private
    
    func textFieldDidChange(notification: NSNotification) {
        validateCheckInputText(newPasswordInput, limit: 20)
        validateCheckInputText(reNewPasswordInput, limit: 20)
    }
    
    private func validateCheckInputText(textInput :UITextField , limit :Int) {
        //ここで文字数を取得して、いい感じに処理します。
        let length = textInput.text!.utf16.count
        
        let maxLength: Int = limit
        
        if (length > maxLength) {
            textInput.text = ""
            textInput.attributedPlaceholder = NSAttributedString(string:"\(limit)文字を超えています。",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            print("\(limit)文字を超えています")
        }
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
    
    
    private func setAlertView (message :String) {
        setAlertView("パスワード変更失敗",message: message, closure: nil)
    }
    
    private func setAlertView (title :String,message :String, closure :(() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { (action :UIAlertAction) -> Void in
            if let notNilClosure = closure {
                notNilClosure()
            }
        })
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

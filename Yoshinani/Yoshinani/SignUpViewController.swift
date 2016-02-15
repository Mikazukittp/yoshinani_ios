//
//  SignUpViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/27.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var addressTextInput: UITextField!
    @IBOutlet weak var accountTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        
        nameTextInput.keyboardType = .EmailAddress
        addressTextInput.keyboardType = .EmailAddress
        accountTextInput.keyboardType = .EmailAddress
        passwordTextInput.keyboardType = .EmailAddress
        
        nameTextInput.returnKeyType = .Done
        addressTextInput.returnKeyType = .Done
        accountTextInput.returnKeyType = .Done
        passwordTextInput.returnKeyType = .Done
        passwordTextInput.secureTextEntry = true
        
        nameTextInput.delegate = self
        addressTextInput.delegate = self
        accountTextInput.delegate = self
        passwordTextInput.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    @IBAction func submitButtonTapped(sender: AnyObject) {
   
        let textFields = [nameTextInput,addressTextInput,accountTextInput,passwordTextInput]
        let isSuccess = self.nilCheck(textFields, alertMessage: "不正な入力値です")

        if isSuccess {
            let session = SignUpSession()
            let property = (accountTextInput.text!, passwordTextInput.text! ,addressTextInput.text! ,nameTextInput.text!)
            session.singUp(property, complition: { (error, user) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if  error {
                        self.setAlertView()
                    }else {
                        if let notNilUser = user {
                            //ログイン情報をRealmに保存する
                            let ruser = RUser()
                            ruser.setProperty(notNilUser)
                            RealmManager.sharedInstance.userInfo = ruser
                        }
                        self.pushToTopViewController()
                    }
                })
            })
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //MARK* Private
    
    func textFieldDidChange(notification: NSNotification) {
        validateCheckInputText(accountTextInput, limit: 15)
        validateCheckInputText(addressTextInput, limit: 20)
        validateCheckInputText(nameTextInput, limit: 15)
        validateCheckInputText(passwordTextInput, limit: 10)
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
    
    
    private func setAlertView () {
        let alertController = UIAlertController(title: "ログイン失敗", message: "ユーザ名もしくはパスワードが間違っています。", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    private func pushToTopViewController () {
        let vc :TopViewController = TopViewController(nibName :"TopViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

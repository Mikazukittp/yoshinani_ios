//
//  LogInViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextInputer: UITextField!
    
    @IBOutlet weak var passwordTextInputer: UITextField!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ログイン"
        self.edgesForExtendedLayout = .None

        nameTextInputer.keyboardType = .EmailAddress
        passwordTextInputer.keyboardType = .EmailAddress
        nameTextInputer.returnKeyType = .Done
        passwordTextInputer.returnKeyType = .Done
        passwordTextInputer.secureTextEntry = true
        
        nameTextInputer.delegate = self
        passwordTextInputer.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        }
        
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    //MARK: IBAction
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
        if  nameTextInputer.text!.isEmpty {
            nameTextInputer.attributedPlaceholder = NSAttributedString(string:"名前を入力してください",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            return
        }
        
        if passwordTextInputer.text!.isEmpty {
            passwordTextInputer.attributedPlaceholder = NSAttributedString(string:"パスワードを入力してください",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            return
        }
        
        if nameTextInputer.markedTextRange != nil {
            return;
        }
        
        if passwordTextInputer.markedTextRange != nil {
            return;
        }
        
        let session = LoginSession()
        session.login(nameTextInputer.text!, pass: passwordTextInputer.text!) { (error, user) -> Void in
            
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
        }
    }

    //MARK* Private
    
    func textFieldDidChange(notification: NSNotification) {
        validateCheckInputText(nameTextInputer)
        validateCheckInputText(passwordTextInputer)
    }
    
   private func validateCheckInputText(textInput :UITextField) {
        //ここで文字数を取得して、いい感じに処理します。
        let length = textInput.text!.utf16.count
        
        let maxLength: Int = 20
        
        if (length > maxLength) {
            textInput.text = ""
            textInput.attributedPlaceholder = NSAttributedString(string:"20文字を超えています。",
                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
            print("20文字を超えています")
        }
    }
    
    private func pushToTopViewController () {
        let vc :TopViewController = TopViewController(nibName :"TopViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    private func setAlertView () {
        let alertController = UIAlertController(title: "ログイン失敗", message: "ユーザ名もしくはパスワードが間違っています。", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    
    
}

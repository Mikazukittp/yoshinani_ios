//
//  SignUpViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/27.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var addressTextInput: UITextField!
    @IBOutlet weak var accountTextInput: UITextField!
    @IBOutlet weak var passwordTextInput: UITextField!
    @IBOutlet weak var rePasswordInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        
        self.title = "新規登録"
        self.screenTitle = "新規登録画面(iOS)"
        
        nameTextInput.keyboardType = .EmailAddress
        addressTextInput.keyboardType = .ASCIICapable
        accountTextInput.keyboardType = .ASCIICapable
        passwordTextInput.keyboardType = .ASCIICapable
        rePasswordInput.keyboardType = .ASCIICapable
        
        nameTextInput.returnKeyType = .Done
        addressTextInput.returnKeyType = .Done
        accountTextInput.returnKeyType = .Done
        passwordTextInput.returnKeyType = .Done
        rePasswordInput.returnKeyType = .Done
        passwordTextInput.secureTextEntry = true
        rePasswordInput.secureTextEntry = true
        
        nameTextInput.delegate = self
        addressTextInput.delegate = self
        accountTextInput.delegate = self
        passwordTextInput.delegate = self
        rePasswordInput.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SignUpViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    @IBAction func submitButtonTapped(sender: AnyObject) {
        
        let textFields = [accountTextInput,passwordTextInput,rePasswordInput]
        var isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
        isSuccess = ValidateUtil.isTextfiledsAlphanumeric(textFields)
        if !isSuccess {
           setAlertView("半角英数字で入力してください。")
            return
        }
        
        if isSuccess {
            
            let password = passwordTextInput.text!
            let repassword = rePasswordInput.text!
            
            if password != repassword {
                setAlertView("パスワードが一致しません")
                return
            }
            
            let session = SignUpSession()
            
            let email = addressTextInput.text!.characters.count > 0 ? addressTextInput.text : nil
            let name = nameTextInput.text!.characters.count > 0 ? nameTextInput.text : nil
            
            let property = (accountTextInput.text!, passwordTextInput.text! ,email ,name)
            print(property)
            self.startIndicator()
            session.singUp(property, complition: { (error, user, message) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()

                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorMessage)
                        break
                    case .Success:
                        if let notNilUser = user {
                            //ログイン情報をRealmに保存する
                            let ruser = RUser()
                            ruser.setProperty(notNilUser)
                            RealmManager.sharedInstance.userInfo = ruser
                        }
                        
                        self.pushToTopViewController()
                        break
                    case .ServerError:
                        let alertMessage = message ?? ServerErrorMessage
                        self.setAlertView(alertMessage)
                        break
                    case .UnauthorizedError:
                        self.popToNewUserController()
                        break
                    }

                })
            })
        }
    }
    
    @IBAction func didTapPrivacyPolicyButton(sender: AnyObject) {
        let vc :PrivacyPolicyViewController = PrivacyPolicyViewController(nibName :"PrivacyPolicyViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapTermsOfService(sender: AnyObject) {
        let vc :TermsOfServiceViewController = TermsOfServiceViewController(nibName :"TermsOfServiceViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //MARK* Private
    
    func textFieldDidChange(notification: NSNotification) {
        validateCheckInputText(accountTextInput, limit: 15)
        validateCheckInputText(addressTextInput, limit: 30)
        validateCheckInputText(nameTextInput, limit: 15)
        validateCheckInputText(passwordTextInput, limit: 20)
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
            if $0.text!.isEmptyField {
                $0.text = nil
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
        let alertController = UIAlertController(title: "登録失敗", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    private func pushToTopViewController () {
        let vc :TopViewController = TopViewController(nibName :"TopViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

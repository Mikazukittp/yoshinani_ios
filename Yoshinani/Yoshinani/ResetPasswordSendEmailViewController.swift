//
//  ResetPasswordSendEmailViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/13.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class ResetPasswordSendEmailViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var mailInput: UITextField!
    @IBOutlet weak var reMailInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)

        self.title = "パスワード再設定"
        self.screenTitle = "パスワード再設定アドレス入力画面(iOS)"

        mailInput.keyboardType = .ASCIICapable
        reMailInput.keyboardType = .ASCIICapable
        
        mailInput.delegate = self
        reMailInput.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    @IBAction func didSubmitTapped(sender: AnyObject) {
        let textFields = [mailInput,reMailInput]
        let isSuccess = self.nilCheck(textFields, alertMessage: "未入力の項目があります")
        
        if isSuccess {
            
            let mail = mailInput.text!
            let reMail = reMailInput.text!
            
            if mail != reMail {
                setAlertView("入力内容に差異があります")
                return
            }
            
            let session = PasswordSession()
            
            self.startIndicator()
            
            session.getToken(mail, complition: { (error, message) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.stopIndicator()
                    
                    switch error {
                    case .NetworkError:
                        self.setAlertView(NetworkErrorMessage)
                        break
                    case .Success:
                        self.setAlertView(SuccessMailTitle, message: SuccessMailBody, closure: { () -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let vc = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle:nil)
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        })
                        break
                    case .ServerError:
                        let alertMessage = message ?? ServerErrorMessage
                        self.setAlertView(alertMessage)
                        break
                    case .UnauthorizedError:
                        break
                    }
                })
            })
        }
 
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    
    //MARK* Private
    
    func textFieldDidChange(notification: NSNotification) {
        validateCheckInputText(mailInput, limit: 30)
        validateCheckInputText(reMailInput, limit: 30)
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

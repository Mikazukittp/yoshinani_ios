//
//  LineLoginViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/04/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class LineLoginViewController: BaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var accountInputFiled: UITextField!
    
    var user :User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        self.title = "LINE新規登録"
        self.screenTitle = "LINE新規登録画面(iOS)"
        
        accountInputFiled.keyboardType = .ASCIICapable
        accountInputFiled.returnKeyType = .Done
        accountInputFiled.delegate = self
    }
    
    @IBAction func didTapSubmitButton(sender: AnyObject) {
        let textFields = [accountInputFiled]
        let isSuccess = self.nilCheck(textFields, alertMessage: "アカウントを入力してください")
        if !isSuccess { return }
        
        guard let account = accountInputFiled.text else { return }
        guard let userId = user?.userId else { return }
        guard let token = user?.token else { return }
        
        let session = UserSession()
        self.startIndicator()
        
        session.update(userId, token: token, account: account) { (error, user) in
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
                    self.setAlertView("他のアカウントを入力してください")
                    break
                case .UnauthorizedError:
                    self.setAlertView(ServerErrorMessage)
                    break
                }
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
        validateCheckInputText(accountInputFiled, limit: 15)
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
        let alertController = UIAlertController(title: "アカウント設定失敗", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func pushToTopViewController () {
        let vc :TopViewController = TopViewController(nibName :"TopViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

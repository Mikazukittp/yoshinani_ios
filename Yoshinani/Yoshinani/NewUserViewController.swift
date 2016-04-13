//
//  NewUserViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class NewUserViewController: BaseViewController {

    @IBOutlet weak var nameTextInputer: UITextField!
    
    @IBOutlet weak var passwordTextInputer: UITextField!
    
    let lineAdapeter = LineAdapter.adapterWithConfigFile()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenTitle = "WellCome画面(iOS)"
        
        nameTextInputer.keyboardType = .ASCIICapable
        passwordTextInputer.keyboardType = .ASCIICapable
        nameTextInputer.returnKeyType = .Done
        passwordTextInputer.returnKeyType = .Done
        passwordTextInputer.secureTextEntry = true
        
        nameTextInputer.delegate = self
        passwordTextInputer.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NewUserViewController.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(NewUserViewController.authorizationDidChange(_:)), name: LineAdapterAuthorizationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //グラデーションの開始色
        let topColor = UIColor(red:0.07, green:0.13, blue:0.26, alpha:1)
        //グラデーションの開始色
        let bottomColor = UIColor.mainColor()
        
        //グラデーションの色を配列で管理
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        
        //グラデーションレイヤーを作成
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        //グラデーションの色をレイヤーに割り当てる
        gradientLayer.colors = gradientColors
        //グラデーションレイヤーをスクリーンサイズにする
        gradientLayer.frame = self.view.bounds
        
        //グラデーションレイヤーをビューの一番下に配置
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)

    }
    
    @IBAction func pushToSignupViewController(sender: AnyObject) {
        let vc = SignUpViewController(nibName :"SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewUserViewController :UITextFieldDelegate {
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
        self.startIndicator()
        session.login(nameTextInputer.text!, pass: passwordTextInputer.text!) { (error, user) -> Void in
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
                        RealmManager.sharedInstance.deleteUserInfo()
                        RealmManager.sharedInstance.userInfo = ruser
                    }
                    
                    //新規プッシュ登録
                    if !UserDefaultManager.sharedInstance.synchronizeApnsToken() {
                        self.sendApnsToken()
                        return
                    }
                    
                    self.pushToTopViewController()
                    break
                case .ServerError:
                    self.setAlertView("ユーザ名もしくはパスワードが間違っています。")
                    break
                case .UnauthorizedError:
                    self.popToNewUserController()
                    break
                }
            })
        }
    }
    @IBAction func didTapResetPasswordButton(sender: AnyObject) {
        let vc = ResetPasswordSendEmailViewController(nibName :"ResetPasswordSendEmailViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapLineLogin(sender: AnyObject) {
        
        if lineAdapeter.authorized {
//            alert("Already authorized", message: "")
            return
        }else {
            if lineAdapeter.canAuthorizeUsingLineApp {
                lineAdapeter.authorize()
                return
            }else{
                let vc = LineAdapterWebViewController.init(adapter: lineAdapeter, withWebViewOrientation: kOrientationAll)
            vc.navigationItem.setLeftBarButtonItem(LineAdapterNavigationController.barButtonItemWithTitle("Cancel", target: self, action: #selector(NewUserViewController.cancel(_:))), animated: true)
                vc.title = "Line Login"
                let nc = LineAdapterNavigationController.init(rootViewController: vc)
                
                self.presentViewController(nc, animated: false, completion: nil)
            }
        }
        
        
        
    }
    func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func authorizationDidChange(notification: NSNotification) {
        let adapter = notification.object as! LineAdapter
        if adapter.authorized {
            
        }else {
             if let error = notification.userInfo?["error"] as? NSError  {
                let errorMessage = error.localizedDescription
                let code = error.code
               kLineAdapterErrorAuthorizationAgentNotAvailable
            }
        }
//        LineAdapter *_adapter = [aNotification object];
//        if ([_adapter isAuthorized])
//        {
//            // Connection completed to LINE.
//        }
//        else
//        {
//            NSError *error = [[aNotification userInfo] objectForKey:@"error"];
//            if (error)
//            {
//                NSString *errorMessage = [error localizedDescription];
//                NSInteger code = [error code];
//                if (code == kLineAdapterErrorMissingConfiguration)
//                {
//                    // URL Types is not set correctly
//                }
//                else if (code == kLineAdapterErrorAuthorizationAgentNotAvailable)
//                {
//                    // The LINE application is not installed
//                }
//                else if (code == kLineAdapterErrorInvalidServerResponse)
//                {
//                    // The response from the server is incorrect
//                }
//                else if (code == kLineAdapterErrorAuthorizationDenied)
//                {
//                    // The user has cancelled the authentication and authorization
//                }
//                else if (code == kLineAdapterErrorAuthorizationFailed)
//                {
//                    // The authentication and authorization has failed for an unknown reason
//                }
//            }
//        }
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
    
    private func setAlertView (message :String) {
        let alertController = UIAlertController(title: "ログイン失敗", message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func sendApnsToken() {
        let deviceToken = UserDefaultManager.sharedInstance.apnsToken()
        
        guard let notNildeviceToken = deviceToken else {
            print("トークンがないよ")
            self.pushToTopViewController()
            return
        }
        
        let session = NotificationSession()
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        guard let notNilUser = user else {
            return
        }
        
        session.create((notNilUser.token,notNilUser.userId,notNildeviceToken)) { (error, message) -> Void in
            if error == ErrorHandring.Success {
                UserDefaultManager.sharedInstance.setSynchronizeApnsToken(true)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.pushToTopViewController()
                })
            print(message)
        }
    }

}

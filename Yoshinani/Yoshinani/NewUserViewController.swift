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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"textFieldDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)

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
}

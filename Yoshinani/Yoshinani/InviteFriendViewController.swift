//
//  InviteFriendViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

protocol InvitedFriendViewControllerDelegate {
    func didSuccessInvitationToUser()
}
class InviteFriendViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user :User?
    var group_id :Int?
    var users :[User] = []
    var delegate :InvitedFriendViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        
        self.title = "メンバー追加"
        self.screenTitle = "友達追加画面(iOS)"
       
        searchBar.keyboardType = .ASCIICapable
        
        let nib = UINib(nibName: "PayerListTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PayerListTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
        
        setScreenStatus()
    }
    
    private func setScreenStatus() {
        var rightButtonTitle = "招待"
        if delegate != nil {
            self.navigationItem.hidesBackButton = true
            rightButtonTitle = "作成"
        }
        
        let rightFooBarButtonItem:UIBarButtonItem = UIBarButtonItem(title:rightButtonTitle , style: UIBarButtonItemStyle.Plain, target: self, action: #selector(InviteFriendViewController.didTapRequestButton))
        self.navigationItem.setRightBarButtonItem(rightFooBarButtonItem, animated: true)
    }
    
    
    func didTapRequestButton() {
        
        if delegate != nil {
            closeSuperView()
        }else {
            closeSelfView()
        }
        
    }
    
    private func closeSuperView() {
        guard users.count > 0 else {
            self.delegate?.didSuccessInvitationToUser()
            return
        }
        
        connectSession {
            self.delegate?.didSuccessInvitationToUser()
        }
    }
    
    private func closeSelfView() {
        guard users.count > 0 else {
            caution("招待できません", message: "ユーザを選択してください")
            return
        }
        
        //追加＋自身のViewを閉じる
        connectSession { 
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func connectSession(complition :() ->Void) {
        
        guard let nonNilUser = RealmManager.sharedInstance.userInfo else{
            return
        }

        let session = GroupSession()
        self.startIndicator()
        session.invite(nonNilUser.userId, token: nonNilUser.token, group_id: group_id!, users: users) { (error,message) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopIndicator()
                switch error {
                case .NetworkError:
                    self.caution(NetworkErrorTitle, message: message ?? ServerErrorMessage)
                    break
                case .Success:
                    self.successAlert(complition)
                    break
                case .ServerError:
                    self.caution("招待できません", message: message ?? ServerErrorMessage)
                    break
                case .UnauthorizedError:
                    self.popToNewUserController()
                    break
                }
            })
        }

    }
}

extension InviteFriendViewController :UITableViewDelegate,UITableViewDataSource {
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if user == nil {
            return 0
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PayerListTableViewCell", forIndexPath: indexPath) as! PayerListTableViewCell
        guard let notNilUser = user else {
            return cell
        }
        
        cell.setName(notNilUser.userName ?? notNilUser.account)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let nonNilUser = user else{
            return
        }
        
        let sameUsers = users.filter{ $0.userId == nonNilUser.userId }
        if sameUsers.count > 0 {
            return
        }
        
        users.append(nonNilUser)
        updateFooterView()
    }
}

extension InviteFriendViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let isSuccess = searchBar.text!.isAlphanumeric()
        if !isSuccess {
            caution("招待できません", message: "英数字を入力してください")
            return
        }
        let user = RealmManager.sharedInstance.userInfo
        
        guard let nonNilUser = user else{
            self.popToNewUserController()
            return
        }
        
        let session = UserSession()
        self.startIndicator()
        
        
        session.search(nonNilUser.userId, token: nonNilUser.token, userName: searchBar.text!) { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopIndicator()

                switch error {
                case .NetworkError:
                    self.caution(NetworkErrorTitle, message: NetworkErrorMessage)
                    break
                case .Success:
                    self.user = session.user
                    self.tableView.reloadData()
                    break
                case .ServerError:
                    self.caution(ServerErrorTitle, message: ServerErrorMessage)
                    break
                case .UnauthorizedError:
                    self.popToNewUserController()
                    break
                }

            })
        }
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
        //ここで文字数を取得して、いい感じに処理します。
        let length = searchText.utf16.count
        
        let maxLength: Int = 20
        
        if (length > maxLength) {
            searchBar.text = ""
            
            let searchTextField: UITextField? = searchBar.valueForKey("searchField") as? UITextField
            if searchTextField!.respondsToSelector(Selector("attributedPlaceholder")) {
                let attributeDict = [NSForegroundColorAttributeName: UIColor.purpleColor()]
                searchTextField!.attributedPlaceholder = NSAttributedString(string: "20文字を超えています。", attributes: attributeDict)
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    private func caution (title: String, message :String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    private func successAlert(complition :() ->Void) {
        let alertController = UIAlertController(title: "招待完了", message: "友人をグループに招待しました。", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) {
            (action:UIAlertAction!) -> Void in
            complition()
        }
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension InviteFriendViewController :InvitedPeopleViewDelegate{
    func updateFooterView () {
        
        //初期化
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        //append
        users.enumerate().forEach{
            let imageView = InvitedPeopleView()
            imageView.setUpLabel($0.1)
            let posX  = CGFloat(integerLiteral: 50 * $0.0)
            imageView.frame = CGRectMake(posX, 0, 50, 50)
            imageView.delegate = self
            imageView.index = $0.0
            scrollView.addSubview(imageView)
        }
        
        //全体のサイズ
        scrollView.contentSize = CGSizeMake(CGFloat(integerLiteral: 100 * users.count), 50)
        // １ページ単位でスクロールさせる
        scrollView.pagingEnabled = true
    }

    func didTapClose(index: Int) {
        users.removeAtIndex(index)
        updateFooterView()
    }
}


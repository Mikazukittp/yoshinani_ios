//
//  InviteFriendViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class InviteFriendViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var user :User?
    var group_id :Int?
    
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
        let myuser = RealmManager.sharedInstance.userInfo
        
        guard let nonNilUser = myuser else{
            return
        }
        
        let session = GroupSession()
        self.startIndicator()
        session.invite(nonNilUser.userId, token: nonNilUser.token, group_id: group_id!, invite_user_id: user!.userId) { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.stopIndicator()
                switch error {
                case .NetworkError:
                    self.caution(NetworkErrorTitle, message: NetworkErrorMessage)
                    break
                case .Success:
                    self.successAlert()
                    break
                case .ServerError:
                    self.caution(ServerErrorTitle, message: "招待できませんでした")
                    break
                case .UnauthorizedError:
                    self.popToNewUserController()
                    break
                }
            })
        }
        
    }
}

extension InviteFriendViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
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
    }
    
    private func successAlert() {
        let alertController = UIAlertController(title: "招待完了", message: "友人をグループに招待しました。", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) {
            (action:UIAlertAction!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}

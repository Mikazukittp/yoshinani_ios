//
//  PayerListViewController.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class PayerListViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    var payerList :[User]?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "PayerListTableViewCell", bundle: nil)
        tableView?.registerNib(nib, forCellReuseIdentifier: "PayerListTableViewCell")
        tableView?.estimatedRowHeight = 50
        tableView?.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: UITableViewDelegate
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notNilPayerList = payerList else {
            return 0
        }
        return (notNilPayerList.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = payerList![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PayerListTableViewCell", forIndexPath: indexPath) as! PayerListTableViewCell
        cell.setName(user.userName)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)        
    }

    
}

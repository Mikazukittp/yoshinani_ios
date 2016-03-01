//
//  MenuProfTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/25.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class MenuProfTableViewCell: UITableViewCell {

    @IBOutlet weak var initialLabel: RoundLabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAcount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabels(user :RUser) {
        self.userName.text = user.userName
        self.userAcount.text = user.account
        self.initialLabel.text = (user.account.uppercaseString as NSString).substringToIndex(1)
    }
    
}

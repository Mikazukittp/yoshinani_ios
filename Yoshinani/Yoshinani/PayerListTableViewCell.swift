//
//  PayerListTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class PayerListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: Public 
    func setName (name :String) {
        nameLabel.text = name
    }
    
    func setChecked (checked :Bool) {
        if checked {
            nameLabel.textColor = yoshinaniColor()
        }else {
            nameLabel.textColor = UIColor.blackColor()
        }
    }
    
}

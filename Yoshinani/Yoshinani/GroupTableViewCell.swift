//
//  GroupTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var toPay: UILabel!

    func setLabels(group :Group, total :Total?) {
        groupName.text = group.name
        
        guard let notNilTotal = total?.result else {
            toPay.text = "¥0"
            return
        }
        
        if notNilTotal < 0 {
            self.toPay.textColor = UIColor.accentColor()
        }else {
            self.toPay.textColor = UIColor.thirdColor()
        }
        
        let toPayStr = Int(round(notNilTotal))
        let payWithComma = StringUtil.cordinateStringWithComma(toPayStr)
        toPay.text = "¥\(payWithComma)"
    }
}

//
//  OverviewTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var toPay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLabels(userNameStr :String, total :Total?) {
        self.userName.text = userNameStr
        
        guard let notNilTotal = total else {
            self.toPay.text = "¥0"
            return
        }
        
        let roundToPay = Int(round(notNilTotal.result ?? 0))
        let payWithComma = StringUtil.cordinateStringWithComma(roundToPay)
        self.toPay.text = "¥\(payWithComma)"
        if roundToPay < 0 {
            toPay.textColor = UIColor.accentColor()
        }else {
            toPay.textColor = UIColor.thirdColor()
        }
    }
    
}

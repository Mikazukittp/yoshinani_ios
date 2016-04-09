//
//  BillTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/30.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: Public
    func setUpParts(payment :Payment) {
        self.nameLabel.text = payment.paid_user?.userName ?? payment.paid_user?.account
        
        self.priceLabel.text = "¥\(StringUtil.cordinateStringWithComma(payment.amount))"
        self.eventLabel.text = payment.event ?? "-"
        self.descriptionLabel.text = payment.description ?? "-"
        self.dateLabel.text = (payment.created_at as NSString).substringToIndex(10) ?? "-"
        print(self.dateLabel)
    }
}

//
//  InviteCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class InviteCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var despName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(entity :Group){
        self.groupName.text = entity.name
        self.despName.text = entity.description
    }
}

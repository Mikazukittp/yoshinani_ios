//
//  RoundLabel.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/25.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class RoundLabel: UILabel {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.width / 2;
        self.clipsToBounds = true;
        self.layer.borderColor = UIColor.mainColor().CGColor
        self.layer.borderWidth = 2
    }
}

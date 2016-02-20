//
//  ToPayUserCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/20.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class ToPayUserCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var box: UIImageView!
    
    var isChecked = false
    
    func setProperties (name :String ,check :Bool) {
        nameLabel.text = name
        isChecked = check
        setImage()
    }
    
    func setImage () {
        if isChecked {
            box.image = UIImage(named: "BoxBlank")!
        }else {
            box.image = UIImage(named: "BoxChecked")!
        }
    }    
}

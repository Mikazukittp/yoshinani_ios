//
//  LoadMoreTableViewCell.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/04/09.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class LoadMoreTableViewCell: UITableViewCell {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var reloadImage: UIImageView!
    
    static let identifier = "LoadMoreTableViewCell"

    func startIndicator() {
        self.indicatorView.hidesWhenStopped = false
        self.indicatorView.startAnimating()
    }
    
    func stopIndicator() {
        self.indicatorView.hidesWhenStopped = true
        self.indicatorView.stopAnimating()
    }
    
    func enableReloadButton() {
        self.reloadImage.hidden = false
    }
    
    func disableReloadButton(){
        self.reloadImage.hidden = true
    }
}

//
//  InvitedPeopleView.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/21.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit


protocol InvitedPeopleViewDelegate {
    func didTapClose(index :Int)
}

class InvitedPeopleView: UIView {
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate :InvitedPeopleViewDelegate?
    var index :Int?
    
    func setUpLabel(user :User) {
        self.nameLabel.text = user.userName
        self.initialLabel.text = (user.account.uppercaseString as NSString).substringToIndex(1)
    }
    
    convenience init(){
        self.init(frame:CGRectZero)
        let subView = loadXib(self)
        self.addFullsizeView(subView)
    }

    
    func addFullsizeView(view:UIView){
        view.autoresizingMask = [.FlexibleWidth ,.FlexibleHeight]
        view.frame = bounds
        addSubview(view)
    }
    
    func loadXib(view:UIView) -> UIView{
        let bundle = NSBundle(forClass: view.dynamicType)
        let classname = NSStringFromClass(view.dynamicType).componentsSeparatedByString(".").last!
        return bundle.loadNibNamed(classname, owner: view, options: nil).first as! UIView
    }

    @IBAction func didTapCloseButton(sender: AnyObject) {
        delegate?.didTapClose(index!)
    }
}

//
//  Ruser.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/31.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class RUser: Object {
    dynamic var token = ""
    dynamic var userId = 0
    dynamic var userName = ""
    dynamic var email = ""
    dynamic var account = ""
    
    //MARK: Init
    func setProperty(user :User) {
        self.token = user.token ?? "0"
        self.userId = user.userId
        self.userName = user.userName ?? ""
        self.email = user.email ?? ""
        self.account = user.account
    }
    
    override static func primaryKey() -> String? {
        return "userId"
    }
    
}
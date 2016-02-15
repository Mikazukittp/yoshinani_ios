//
//  User.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/31.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import Unbox

struct User: Unboxable {
    let token: String?
    let userId: Int
    let userName: String
    let email: String
    let totals :[Total]?
    let invitedGroups :[Group]?
    let activeGroups :[Group]?
    
    init(unboxer: Unboxer) {
        self.token = unboxer.unbox("token")
        print(self.token)
        self.userId = unboxer.unbox("id")
        print(self.userId)
        self.userName = unboxer.unbox("username")
        print(self.userName)
        self.email = unboxer.unbox("email")
        print(self.email)
        self.totals = unboxer.unbox("totals")
        self.invitedGroups = unboxer.unbox("invited_groups")
        self.activeGroups = unboxer.unbox("active_groups")
    }
    
    init(token: String, userId: Int, userName: String, email :String) {
        self.token = token
        self.userId = userId
        self.userName = userName
        self.email = email
        self.totals = nil
        self.invitedGroups = nil
        self.activeGroups = nil
    }
}
//
//  UserManager.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class UserInfoManager  {
    
    static let sharedInstance = UserInfoManager()
    
    private init() {
        // Initialization here
    }
    
    // 規定値を管理します。
    var userInfo: User? {
        get {
            let user = User(
                token: Defaults[.userName],
                userId: Defaults[.userId],
                userName: Defaults[.userName],
                email: Defaults[.email])
            
            return user
        }
        set(userInfo) {
            Defaults[.userName] = userInfo!.userName
            Defaults[.email] = userInfo!.email
            Defaults[.userId] = userInfo!.userId
            Defaults[.token] = userInfo!.token!
        }
    }
}

extension DefaultsKeys {
    static let userName = DefaultsKey<String>("userName")
    static let email = DefaultsKey<String>("email")
    static let userId = DefaultsKey<Int>("userId")
    static let token = DefaultsKey<String>("token")
}

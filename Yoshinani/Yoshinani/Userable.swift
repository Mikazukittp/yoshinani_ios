//
//  Userable.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

protocol Userable {
    var userInfo :RUser? {get set}
    func userInfoFromRealm() -> RUser?
}

extension Userable {
    func userInfoFromRealm() -> RUser?{
       let user = RealmManager.sharedInstance.userInfo
        return user
    }
}



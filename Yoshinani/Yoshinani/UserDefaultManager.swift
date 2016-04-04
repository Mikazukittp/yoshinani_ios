//
//  UserDefaultManager.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/21.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

class UserDefaultManager: NSObject {

    static let sharedInstance = UserDefaultManager()
    
    let ud = NSUserDefaults.standardUserDefaults()
    
    func apnsToken() -> String? {
       return ud.objectForKey("APnsToken") as? String
    }
    func setApnsToken(value :String) {
        ud.setObject(value, forKey: "APnsToken")
    }
    func synchronizeApnsToken() -> Bool {
        return ud.boolForKey("synchronizeApnsToken")
    }
    
    func setSynchronizeApnsToken(value :Bool) {
        ud.setBool(value, forKey: "synchronizeApnsToken")
    }
}

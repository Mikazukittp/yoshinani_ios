//
//  RealmManager.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager  {
    
    static let sharedInstance = RealmManager()
    
    let realm = try! Realm()
    
    private init() {
        // Initialization here
    }
    
    // 規定値を管理します。
    var userInfo: RUser? {
        get {
            let users = realm.objects(RUser)
            if users.isEmpty {return nil}
            return users[0]
        }
        set(userInfo) {
            try! realm.write {
                realm.add(userInfo!, update: true)
            }
        }
    }
    
    func deleteUserInfo () {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

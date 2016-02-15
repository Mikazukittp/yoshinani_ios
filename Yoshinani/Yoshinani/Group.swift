//
//  Group.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/12.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import Unbox

struct Group: Unboxable {
    let group_id: Int
    let name: String
    let description: String
    let activeUsers :[User]?

    init(unboxer: Unboxer) {
        self.group_id = unboxer.unbox("id")
        self.name = unboxer.unbox("name")
        self.description = unboxer.unbox("description")
        self.activeUsers = unboxer.unbox("active_users")
    }
}
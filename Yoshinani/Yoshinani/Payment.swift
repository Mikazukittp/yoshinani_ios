//
//  Payment.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/02.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import Unbox

struct Payment: Unboxable {
    let payment_id: Int
    let amount :Int
    let event: String
    let description: String
    let created_at: String
    let paid_user: User?
    let participants: [User]?
    
    init(unboxer: Unboxer) {
        self.payment_id = unboxer.unbox("id")
        print(self.payment_id)
        self.event = unboxer.unbox("event")
        self.amount = unboxer.unbox("amount")
        self.description = unboxer.unbox("description")
        self.created_at = unboxer.unbox("created_at")
        self.paid_user = unboxer.unbox("paid_user")
        self.participants = unboxer.unbox("participants")
    }
    
    init(amount :Int, event :String,description :String,created_at :String,paid_user :User){
        self.payment_id = 0
        self.event = event
        self.amount = amount
        self.description = description
        self.created_at = created_at
        self.paid_user = paid_user
        self.participants = nil
    }
}
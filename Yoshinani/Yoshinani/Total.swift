//
//  Totals.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/14.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import Unbox

struct Total: Unboxable {
    let paid: String?
    let to_pay: String?
    let group_id: Int
    let user_id: Int
    let result :Double?
    
    init(unboxer: Unboxer) {
        self.paid = unboxer.unbox("paid")
        self.to_pay = unboxer.unbox("to_pay")
        self.group_id = unboxer.unbox("group_id")
        self.user_id = unboxer.unbox("user_id")
        
        guard let notNilPaid = Double(paid!) else {
            self.result = nil
            return
        }
        guard let notNilToPay = Double(to_pay!) else {
            self.result = nil
            return
        }
        self.result = notNilPaid - notNilToPay
        print(self)
    }
}
 


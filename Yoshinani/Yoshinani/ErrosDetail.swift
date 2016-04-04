//
//  ErrosDetail.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/10.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import Unbox

struct ErrorDetail: Unboxable {
    let password: [String]?
    let base :[String]?
    
    init(unboxer: Unboxer) {
        self.password = unboxer.unbox("password")
        self.base = unboxer.unbox("base")
        print(self)
    }
}
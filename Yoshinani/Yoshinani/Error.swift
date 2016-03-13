//
//  Error.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/09.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import Unbox

struct Error: Unboxable {
    let message: String
    let errors: ErrorDetail?
    
    init(unboxer: Unboxer) {
        self.message = unboxer.unbox("message")
        self.errors = unboxer.unbox("errors")
        print(self)
    }
}
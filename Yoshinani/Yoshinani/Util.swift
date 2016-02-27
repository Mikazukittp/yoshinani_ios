//
//  Util.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/25.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit

struct UIScreenUtil {
    static func bounds()->CGRect{
        return UIScreen.mainScreen().bounds;
    }
    static func screenWidth()->Int{
        return Int( UIScreen.mainScreen().bounds.size.width);
    }
    static func screenHeight()->Int{
        return Int(UIScreen.mainScreen().bounds.size.height);
    }
}

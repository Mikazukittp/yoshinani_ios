//
//  Const.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/31.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class Const {
    class var urlDomain: String {
        return "http://52.193.62.129/api/v1/"
        
        //http://52.193.62.129/api/v1/: 開発
        //http://52.69.32.124/api/v1 :本番
    }
}

func yoshinaniColor() -> UIColor {
    return UIColor(red: 0.443, green: 0.769, blue: 0.784, alpha: 1.0)
}

func participants_ids(users :[User], checked :[Bool]) -> [Int] {
    var participants :[Int] = []
    for (index, score) in checked.enumerate() {
        print("index:\(index), score: \(score)")
        if score {
            participants.append(users[index].userId)
        }
    }
    return participants
}
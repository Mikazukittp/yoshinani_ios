//
//  UIColor+Addition.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/20.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit


extension UIColor {
    class func mainColor() -> UIColor {
        return self.hexStr("00897B", alpha: 1.0)
    }
    
    class func subColor() -> UIColor {
        return self.hexStr("00695C", alpha: 1.0)
    }
    
    class func thirdColor() -> UIColor {
        return self.hexStr("26A69A", alpha: 1.0)
    }
    
    class func accentColor() -> UIColor {
        return self.hexStr("E67F4F", alpha: 1.0)
    }
    
    class func letterColor() -> UIColor {
        return self.hexStr("424242", alpha: 1.0)
    }
    
    class func hexStr (var hexStr : NSString, alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
}


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


struct StringUtil {
    static func cordinateStringWithComma(value :Int) -> String {
        let num = NSNumber(integer: value)
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.stringFromNumber(num) ?? "0"
    }
    
    static func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    static func hasString(string :String?) -> Bool {
        
        //nilチェック
        guard let notNilString = string else{
            return false
        }
        
        //空文字チェク
        if notNilString.isEmptyField {
            return false
        }
        
        return true
    }
}

struct ValidateUtil {
    static func isTextfiledsAlphanumeric(textFields :[UITextField!]) -> Bool {
        var isSuccess = true
        
        textFields.forEach {
            if !$0.text!.isAlphanumeric() {
                isSuccess = false
            }
        }
        return isSuccess
    }
}

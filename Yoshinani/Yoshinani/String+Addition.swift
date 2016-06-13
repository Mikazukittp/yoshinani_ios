//
//  String+Addition.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/06/07.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit


extension String {
    /**
     半角英数チェック
     
     :param: string 対象文字列
     
     :returns: バリデーションが通ればtrue
     */
    func isAlphanumeric() -> Bool {
        return checkRegularExpression(pattern: "[a-zA-Z0-9]+")
    }
    
    /**
     正規表現ベース
     
     :param: string  対象文字列
     :param: pattern 正規表現制約
     
     :returns: バリデーションが通ればtrue
     */
    private func checkRegularExpression(pattern pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluateWithObject(self)
    }
    
    var isEmptyField: Bool {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
    }
}
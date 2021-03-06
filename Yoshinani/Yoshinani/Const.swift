//
//  Const.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/31.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit

class Const {
    //http://52.193.62.129/api/v1: 開発
    //http://52.69.32.124/api/v1 :本番
    
    #if DEBUG
    let urlDomain = "http://52.193.62.129/api/v1"
    #else
    let urlDomain = "http://52.69.32.124/api/v1"
    #endif
    
    #if DEBUG
    let urlAdmob = "ca-app-pub-3940256099942544/2934735716"
    #else
    let urlAdmob = "ca-app-pub-8668651775161815/1088420289"
    #endif

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

let NetworkErrorTitle = "通信エラー"
let NetworkErrorMessage = "通信環境の良い場所で通信してください"
let ServerErrorTitle = "サーバエラー"
let ServerErrorMessage = "処理を受け付けることができませんでした"
let RequestErrorMessage = "入力項目に誤りがあります"
let SuccessTitle = "通信成功"
let PasswordMessage = "パスワードの変更が完了しました"
let SuccessMailTitle = "メール送信完了"
let SuccessMailBody = "指定されたアドレスにメールを送信しました"
let UpdateNotification = "UpdateNotification"
let SortWord = "!rhd2014"

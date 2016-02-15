//
//  LoginSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/31.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import Unbox
import RealmSwift

class LoginSession: NSObject {

    func login (account :String,pass :String,complition :(error :Bool, user :User?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/sign_in")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        
        let postString:String = "account=\(account)&password=\(pass)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                complition(error: true, user: nil)
            } else {
                guard let notNilResponse = response else {
                    complition(error: true, user: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    complition(error: true, user: nil)
                    return
                }
                
                let user :User? = Unbox(data!)
                guard let notNilUser = user else{
                    complition(error: false, user: nil)
                    return
                }
                
                complition(error: false, user: notNilUser)
            }
        })
        dataTask.resume()
    }

}

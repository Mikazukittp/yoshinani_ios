
//
//  SignUpSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/02/11.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox

class SignUpSession: NSObject {

    func singUp (property :(account: String,password: String,email :String,username :String),complition :(error :Bool , user :User?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let userDict:Dictionary<String,String>  = [
            "account":property.account,
            "password":property.password,
            "email":property.email,
            "username":property.username
        ]
        let params = ["user":userDict]
        
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted) //(*)options??
            request.HTTPBody = jsonData
        } catch {
            print("Error!: \(error)")
        }
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            print(response)
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
                guard let notniluser = user else {
                    complition(error: false, user: nil)
                    return
                }
                
                complition(error: false, user: notniluser)
            }
        })
        dataTask.resume()
    }

}

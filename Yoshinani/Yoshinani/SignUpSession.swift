
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

    func singUp (property :(account: String,password: String,email :String?,username :String?),complition :(error :ErrorHandring , user :User?, meesage: String?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        var userDict:Dictionary<String,String>  = [
            "account":property.account,
            "password":property.password,
        ]
        if let notNilEmail = property.email {
            userDict["email"] = notNilEmail
        }
        if let notNilName = property.username {
            userDict["username"] = notNilName
        }
        
        let params = ["user":userDict]
        print(params)
        
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted) //(*)options??
            request.HTTPBody = jsonData
        } catch {
            print("Error!: \(error)")
        }
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError, user: nil, meesage: nil)
                }

            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, user: nil, meesage: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                     let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .UnauthorizedError, user: nil,meesage: error.message)
                        return
                    }
                    complition(error: .UnauthorizedError, user: nil,meesage: message[0])
                    return
                }else if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError, user: nil,meesage: error.message)
                        return
                    }
                    complition(error: .ServerError, user: nil,meesage: message[0])
                    return
                }

                
                let user :User? = Unbox(data!)
                guard let notniluser = user else {
                    complition(error: .ServerError, user: nil, meesage: nil)
                    return
                }
                
                complition(error: .Success, user: notniluser, meesage: nil)
            }
        })
        dataTask.resume()
    }

}

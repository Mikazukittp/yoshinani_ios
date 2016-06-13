
//
//  PasswordSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/09.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox


class PasswordSession: NSObject {
    
    func change (uid: Int,token :String,property :(password: String,newPassword: String,newPasswordConfirm :String),complition :(error :ErrorHandring , user :User?, message :String?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/passwords")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "PATCH"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let userDict:Dictionary<String,String>  = [
            "password":property.password,
            "new_password":property.newPassword,
            "new_password_confirmation":property.newPasswordConfirm
        ]
        
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
                    complition(error: .NetworkError, user: nil, message: nil)
                }
                
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, user: nil, message: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .UnauthorizedError, user: nil, message: error.message)
                        return
                    }
                    complition(error: .UnauthorizedError, user: nil, message: message[0])
                    return
                }else if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError, user: nil, message: error.message)
                        return
                    }
                    complition(error: .ServerError, user: nil, message: message[0])
                    return
                }
                
                
                let user :User? = Unbox(data!)
                guard let notniluser = user else {
                    complition(error: .ServerError, user: nil, message: nil)
                    return
                }
                
                complition(error: .Success, user: notniluser, message:  nil)
            }
        })
        dataTask.resume()
    }
    
    func getToken (email :String,complition :(error :ErrorHandring, message :String?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/passwords/init")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let userDict:Dictionary<String,String>  = [
            "email":email,
        ]
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
                    complition(error: .NetworkError, message: nil)
                }
                
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, message: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError, message: error.message)
                        return
                    }
                    complition(error: .ServerError, message: message[0])
                    return
                }
                
                complition(error: .Success, message:  nil)
            }
        })
        dataTask.resume()
    }
    func reset (property :(confirmKey: String,newPassword: String,newPasswordConfirm :String),complition :(error :ErrorHandring , user :User?, message :String?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/passwords/reset")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "PATCH"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let userDict:Dictionary<String,String>  = [
            "reset_password_token":property.confirmKey,
            "new_password":property.newPassword,
            "new_password_confirmation":property.newPasswordConfirm
        ]
        
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
                    complition(error: .NetworkError, user: nil, message: nil)
                }
                
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, user: nil, message: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError, user: nil, message: error.message)
                        return
                    }
                    complition(error: .ServerError, user: nil, message: message[0])
                    return
                }
                
                let user :User? = Unbox(data!)
                guard let notniluser = user else {
                    complition(error: .ServerError, user: nil, message: nil)
                    return
                }
                
                complition(error: .Success, user: notniluser, message:  nil)
            }
        })
        dataTask.resume()
    }
    
}

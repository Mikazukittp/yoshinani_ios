//
//  UserSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/12.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox

class UserSession: NSObject {
    
    var users :[User]?
    var user :User?
    
    func users (uid: Int,token :String, groud_id :Int, complition :(error :ErrorHandring) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users?group_id=" + String(groud_id))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        session.cancelAllTasks()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError)
                    return
                }else if httpResponse.statusCode != 200 {
                    complition(error: .ServerError)
                    return
                }
                
                self.users = Unbox(data!)
                print(self.users)

                
                complition(error: .Success)
            }
        })
        dataTask.resume()
    }
    
    func show(uid :Int,  token :String, complition:(error :ErrorHandring) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/" + String(uid))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        print(uid)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        session.cancelAllTasks()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError)
                    return
                }else if httpResponse.statusCode != 200 {
                    complition(error: .ServerError)
                    return
                }
                self.user = Unbox(data!)
                print(self.user)
                
                complition(error: .Success)
            }
        })
        dataTask.resume()
    }
    
    //users/search?account=#{アカウント名}
    func search(uid: Int, token:String ,userName :String,complition:(error :ErrorHandring) ->Void){
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/search?account=" + String(userName))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        print(userName)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        session.cancelAllTasks()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError)
                    return
                }else if httpResponse.statusCode != 200 {
                    complition(error: .ServerError)
                    return
                }
                self.user = Unbox(data!)
                print(self.user)
                
                complition(error: .Success)
            }
        })
        dataTask.resume()

    }
}

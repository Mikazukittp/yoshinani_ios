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
    
    func users (uid: Int,token :String, groud_id :Int, complition :(error :Bool) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users?group_id=" + String(groud_id))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                complition(error: true)
            } else {
                guard let notNilResponse = response else {
                    complition(error: true)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    complition(error: true)
                    return
                }
                
                self.users = Unbox(data!)
                print(self.users)
                
                complition(error: false)
            }
        })
        dataTask.resume()
    }
    
    func show(uid :Int,  token :String, complition:(error :Bool) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/" + String(uid))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        print(uid)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                complition(error: true)
            } else {
                guard let notNilResponse = response else {
                    complition(error: true)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    complition(error: true)
                    return
                }
                
                self.user = Unbox(data!)
                print(self.user)
                
                complition(error: false)
            }
        })
        dataTask.resume()
    }
    
    //users/search?account=#{アカウント名}
    func search(uid: Int, token:String ,userName :String,complition:(error :Bool) ->Void){
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/search?account=" + String(userName))!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        print(userName)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                complition(error: true)
            } else {
                guard let notNilResponse = response else {
                    complition(error: true)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode != 200 {
                    complition(error: true)
                    return
                }
                
                self.user = Unbox(data!)
                print(self.user)
                
                complition(error: false)
            }
        })
        dataTask.resume()

    }
}

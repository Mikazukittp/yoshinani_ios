//
//  GroupSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/12.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox

class GroupSession: NSObject {
    
    var groups :[Group]?
    var group :Group?
    
    func groups (uid: Int,token :String, complition :(error :ErrorHandring) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
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
                
                self.groups = Unbox(data!)
                print(self.groups)
                
                complition(error: .Success)
            }
        })
        dataTask.resume()
    }
    
    func create (uid: Int,token :String,name: String, desp :String, complition :(error :ErrorHandring, group_id :Int?) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        
        let groupDict:Dictionary<String,String>  = [
            "name":name,
            "description":desp,
        ]
        let params = ["group":groupDict]
        
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
                    complition(error: .NetworkError, group_id: nil)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, group_id: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError, group_id: nil)
                    return
                }else if httpResponse.statusCode != 200 {
                    complition(error: .ServerError, group_id: nil)
                    return
                }
                
                self.group = Unbox(data!)
                print(self.group)

                complition(error: .Success,group_id: self.group?.group_id)
            }
            
        })
        dataTask.resume()
    }
    
    func accept(uid :Int, token :String, group_id :Int ,complition :(error :ErrorHandring) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups/\(group_id)/users/accept")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "PATCH"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
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
                
                complition(error: .Success)
            }
        })
        dataTask.resume()
    }
    
    func destroy(uid :Int,token :String,group_id :Int, user_id :Int,complition :(error :ErrorHandring) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups/\(group_id)/users/\(user_id)")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "DELETE"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
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
                complition(error: .Success)
            }
        })
        dataTask.resume()
    }
    
    func invite(uid :Int, token :String,group_id: Int,users :[User],complition :(error :ErrorHandring, message: String?) ->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups/\(group_id)/users/")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let userDicts = users.map{["user_id":$0.userId]}
        print(userDicts)
        
        let userParams = ["group_user":userDicts]
        print(userParams)
                
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(userParams, options: .PrettyPrinted) //(*)options??
            request.HTTPBody = jsonData
        } catch {
            print("Error!: \(error)")
        }
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError, message: NetworkErrorMessage)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, message: ServerErrorMessage)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError, message: "")
                    return
                }else if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.base else {
                        complition(error: .ServerError, message: error.message)
                        return
                    }
                    complition(error: .ServerError, message: message[0])
                    return
                }
                self.groups = Unbox(data!)
                print(self.groups)

                complition(error: .Success,message: nil)
            }
            
        })
        dataTask.resume()
    }
    
    func users(uid :Int,token :String,group_id :Int,complition :(error :ErrorHandring) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/groups/\(group_id)")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let session = NSURLSession.sharedSession()
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
                
                self.group = Unbox(data!)
                print(self.group)
                
                complition(error: .Success)
            }
            

        })
        dataTask.resume()

    }

}

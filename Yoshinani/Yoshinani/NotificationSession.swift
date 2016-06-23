
//
//  NotificationSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/03/21.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox

class NotificationSession: NSObject {
    
    func create (property :(token: String,userId: Int,gcmToken :String),complition :(error :ErrorHandring, message: String?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const().urlDomain + "/notification_tokens")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(property.userId), forHTTPHeaderField: "uid")
        request.addValue(property.token, forHTTPHeaderField: "token")

        let userDict:Dictionary<String,String>  = [
            "device_token":property.gcmToken,
            "device_type":"ios",
        ]
        
        let params = ["notification_token":userDict]
        print(params)
        
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted) //(*)options??
            request.HTTPBody = jsonData
        } catch {
            print("Error!: \(error)")
        }
        
        let semaphore = dispatch_semaphore_create(0)
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError, message: nil)
                    dispatch_semaphore_signal(semaphore)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, message: nil)
                    dispatch_semaphore_signal(semaphore)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .UnauthorizedError,message: error.message)
                        dispatch_semaphore_signal(semaphore)
                        return
                    }
                    complition(error: .UnauthorizedError,message: message[0])
                    dispatch_semaphore_signal(semaphore)
                    return
                }else if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError,message: error.message)
                        dispatch_semaphore_signal(semaphore)
                        return
                    }
                    complition(error: .ServerError,message: message[0])
                    dispatch_semaphore_signal(semaphore)
                    return
                }
                
                complition(error: .Success, message: nil)
                dispatch_semaphore_signal(semaphore)
            }
        })
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}

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


enum ErrorHandring :Int {
    case Success
    case NetworkError
    case UnauthorizedError
    case ServerError
}

class LoginSession: NSObject {

    func login (account :String,pass :String,complition :(error :ErrorHandring, user :User?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/users/sign_in")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        
        let postString:String = "account=\(account)&password=\(pass)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        let session = NSURLSession.sharedSession()
        session.cancelAllTasks()
        
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError, user: nil)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, user: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    complition(error: .UnauthorizedError, user: nil)
                    return
                }else if httpResponse.statusCode != 200 {
                    complition(error: .ServerError, user: nil)
                    return
                }
                
                let user :User? = Unbox(data!)
                guard let notNilUser = user else{
                    complition(error: .ServerError, user: nil)
                    return
                }
                
                complition(error: .Success, user: notNilUser)
            }
        })
        dataTask.resume()
    }
}

extension NSURLSession {
    func cancelAllTasks() {
        self.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            dataTasks.forEach {
                if $0.state == .Running {
                    $0.cancel()
                }
            }
        }
    }
}

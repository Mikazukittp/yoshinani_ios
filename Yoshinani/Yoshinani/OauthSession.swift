//
//  OauthSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/04/13.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox

class OauthSession: NSObject {
    func create (thirdPartyId :String,complition :(error :ErrorHandring, message: String?, user :User?) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/oauth_registrations")!,
                                          cachePolicy: .UseProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let userDict:Dictionary<String,AnyObject>  = [
            "third_party_id":thirdPartyId,
            "oauth_id":1,
            "sns_hash_id": StringUtil.md5(string: thirdPartyId + SortWord)
        ]
        
        let params = ["oauth_registration":userDict]
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
                print(error)
                if error!.code != NSURLError.Cancelled.rawValue {
                    complition(error: .NetworkError, message: nil, user: nil)
                }
            } else {
                guard let notNilResponse = response else {
                    complition(error: .ServerError, message: nil, user: nil)
                    return
                }
                
                let httpResponse = notNilResponse as! NSHTTPURLResponse
                if httpResponse.statusCode == 401 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .UnauthorizedError,message: error.message, user: nil)
                        return
                    }
                    complition(error: .UnauthorizedError,message: message[0], user: nil)
                    return
                }else if httpResponse.statusCode != 200 {
                    let error :Error = Unbox(data!)!
                    guard let message = error.errors?.password else {
                        complition(error: .ServerError,message: error.message, user: nil)
                        return
                    }
                    complition(error: .ServerError,message: message[0], user: nil)
                    return
                }
                
                let user :User = Unbox(data!)!
                complition(error: .Success, message: nil, user: user)
            }
        })
        dataTask.resume()
    }
}

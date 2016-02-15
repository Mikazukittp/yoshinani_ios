//
//  PaymentSession.swift
//  Yoshinani
//
//  Created by 石部達也 on 2016/01/01.
//  Copyright © 2016年 石部達也. All rights reserved.
//

import UIKit
import Unbox
import RealmSwift

class PaymentSession: NSObject {
    
    var payments :[Payment]?
    
    func payments (uid :Int, pass :String, group_id :Int , complition :(error :Bool) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/payments?group_id=\(group_id)")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(pass, forHTTPHeaderField: "token")
        
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
                
                self.payments = Unbox(data!)
                print(self.payments)
                
                complition(error: false)
            }
        })
        dataTask.resume()
    }
    
    func create (uid :Int, pass :String,payment :Payment,group_id :Int,participants: [Int], complition :(error :Bool) ->Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: Const.urlDomain + "/payments")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("\(uid)", forHTTPHeaderField: "uid")
        request.addValue(pass, forHTTPHeaderField: "token")
        
        let paymentDict:Dictionary<String,AnyObject>  = [
            "amount":String(payment.amount),
            "group_id":String(group_id),
            "event":payment.event,
            "description":payment.description,
            "date":payment.created_at,
            "paid_user_id":String((payment.paid_user?.userId)!),
            "is_repayment": false,
            "participants_ids":participants
        ]
        
        let params = ["payment":paymentDict]
        print(params)
        
        do {
            // Dict -> JSON
            let jsonData = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted) //(*)options??
            request.HTTPBody = jsonData
            
            let json = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            print(json)

        } catch {
            print("Error!: \(error)")
        }

        
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
                if httpResponse.statusCode != 201 {
                    complition(error: true)
                    return
                }
                
                let payment :Payment? = Unbox(data!)
                print(payment)
                
                complition(error: false)
            }
        })
        dataTask.resume()
    }


}

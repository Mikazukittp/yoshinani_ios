//
//  AppDelegate.swift
//  Yoshinani
//
//  Created by 石部達也 on 2015/12/24.
//  Copyright © 2015年 石部達也. All rights reserved.
//

import UIKit
import REFrostedViewController
import RealmSwift
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,REFrostedViewControllerDelegate {

    var window: UIWindow?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let win = window {
            win.opaque = true
            
            //Realmのデータを取得
            let user = RealmManager.sharedInstance.userInfo
            
            //小ビューコントローラで、強制的にTOPに戻した時のために一番下のレイヤーにこの画面を設定しておく。
            var vc: UIViewController =  NewUserViewController(nibName: "NewUserViewController", bundle:nil)

            if let _ = user {
                vc = TopViewController(nibName: "TopViewController", bundle: nil)
            }
            let MenuNC = MenuNavigationController(rootViewController: vc)
            let menuVC = MenuTableViewController()
            
            let frostedVC = REFrostedViewController(contentViewController: MenuNC, menuViewController: menuVC)
            frostedVC.direction = REFrostedViewControllerDirection.Left;
            
            //GA
            // Configure tracker from GoogleService-Info.plist.
            var configureError:NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")

            // Optional: configure GAI options.
            let gai = GAI.sharedInstance()
            gai.trackUncaughtExceptions = true  // report uncaught exceptions
            gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
            

            win.rootViewController = frostedVC
            win.makeKeyAndVisible()
            
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
            UINavigationBar.appearance().tintColor = UIColor.whiteColor()
            UINavigationBar.appearance().barTintColor = UIColor.mainColor()
            
            // バッジ、サウンド、アラートをリモート通知対象として登録する
            let settings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories:nil)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            
        }
        return true
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
                .stringByTrimmingCharactersInSet( characterSet )
                .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        print("ApnsToken:" + deviceTokenString)
            
        UserDefaultManager.sharedInstance.setApnsToken(deviceTokenString)
        
        if !UserDefaultManager.sharedInstance.synchronizeApnsToken() {
            sendApnsToken()
        }
    }
    private func sendApnsToken() {
        let deviceToken = UserDefaultManager.sharedInstance.apnsToken()
        
        guard let notNildeviceToken = deviceToken else {
            print("トークンがないよ")
            return
        }
        
        let session = NotificationSession()
        //Realmのデータを取得
        let user = RealmManager.sharedInstance.userInfo
        guard let notNilUser = user else {
            return
        }
        
        session.create((notNilUser.token,notNilUser.userId,notNildeviceToken)) { (error, message) -> Void in
            if error == ErrorHandring.Success {
                UserDefaultManager.sharedInstance.setSynchronizeApnsToken(true)
            }
            print(message)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


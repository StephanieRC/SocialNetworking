//
//  AppDelegate.swift
//  SocialNetworking
//
//  Created by stephanie Cappello on 11/16/18.
//  Copyright © 2018 stephanie Cappello. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Fabric
import Crashlytics
import GoogleSignIn
import FBSDKCoreKit
import FirebaseAuth
import GoogleMaps

let googlekey = "AIzaSyCp4OK4MNG3dZvEhUjSVzhsPu0i2Raz-Tw"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GMSServices.provideAPIKey(googlekey)
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if let curUser = Auth.auth().currentUser {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabbarController")
            self.window?.rootViewController = controller
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //self.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googlehandler = GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,annotation: [:])
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: [:])
        
        return googlehandler||facebookDidHandle
    }
    
    
}


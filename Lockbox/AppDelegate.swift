//
//  AppDelegate.swift
//  Lockbox
//
//  Created by XunGong on 2015-06-16.
//  Copyright (c) 2015 XunGong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        backgroundImageIndex = NSUserDefaults.standardUserDefaults().integerForKey("Background Image Index")
        var index = 0
        while UIImage(named: "background\(index)") != nil {
            backgroundImages.append(UIImage(named: "background\(index++)"))
        }
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let hasPassword = NSUserDefaults.standardUserDefaults().objectForKey("has password") as? Bool {
            let topController = topMostViewController()
            let passwordViewController = topController.storyboard?.instantiateViewControllerWithIdentifier("Password") as? PasswordViewController
            passwordViewController?.controllerType = .checkPW
            topController.presentViewController(passwordViewController!, animated: true, completion: nil)
        }
    }
    func topMostViewController() -> UIViewController {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController!
    }
}



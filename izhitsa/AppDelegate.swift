//
//  AppDelegate.swift
//  izhitsa
//
//  Created by Дмитрiй Канунниковъ on 19.07.2019.
//  Copyright © 2019 Dmitry Kanunnikoff. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs.
        FirebaseApp.configure()
        
        Fabric.with([Crashlytics.self])
        
        //---
        
        SKPaymentQueue.default().add(StoreObserver.shared())
        
        //---
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(StoreObserver.shared())
    }
}

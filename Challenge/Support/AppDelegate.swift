//
//  AppDelegate.swift
//  Challenge
//
//  Created by John Lima on 09/08/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldRotate = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        guard UIDevice.current.userInterfaceIdiom != .pad else { return .landscape }
        return shouldRotate ? .all : .portrait
    }
}


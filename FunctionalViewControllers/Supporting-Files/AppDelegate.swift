//
//  AppDelegate.swift
//  FunctionalViewControllers
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

// TODO: a ViewController should be only generic over the result!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window?.rootViewController = run(navigation, artists) { artist in
            println("Selected \(artist.name)")
        }
        return true
    }
}
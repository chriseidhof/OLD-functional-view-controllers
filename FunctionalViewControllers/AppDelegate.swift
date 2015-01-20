//
//  AppDelegate.swift
//  FunctionalViewControllers
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

// TODO: a ViewController should be only generic over the result!

struct Album {
    let name: String
}

struct Artist {
    let name : String
    let additionalInformation : String
    let albums: [Album]
}

let artists : [Artist] = [
    Artist(name: "JS Bach", additionalInformation: "Some more info", albums: [Album(name: "The Art of Fugue")]),
    Artist(name: "Simeon Ten Holt", additionalInformation: "Bla bla", albums: [])
]

let chooseArtist: ViewController<[Artist], Artist> = tableViewController { cell, artist in
    cell.textLabel!.text = artist.name
    return cell
}

let chooseAlbum: ViewController<[Album],Album> = tableViewController { cell, album in
    cell.textLabel?.text = album.name
    return cell
}

let navigation = rootViewController(chooseArtist).map { $0.albums } >>> chooseAlbum


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        window?.rootViewController = run(navigation, artists) { artist in
            println("Selected \(artist.name)")
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


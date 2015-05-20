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

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window?.rootViewController = run(navigation, artists) { artist in
            println("Selected \(artist.name)")
        }
        return true
    }
}
//
//  MusicApp.swift
//  FunctionalViewControllers
//
//  Created by James Valaitis on 20/05/2015.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

import Foundation

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
//
//  CollectionViewController.swift
//  FunctionalViewControllers
//
//  Created by James Valaitis on 20/05/2015.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

import UIKit

//	MARK: Creation

/**
	Returns a ViewController that will create a TableViewController with [A] items and returning the selected item A upon completion.
*/
func collectionViewController<A>(render: (UICollectionViewCell, A) -> UICollectionViewCell) -> ViewController<[A],A> {
	
	return ViewController(create: { (items: [A], callback: A -> ()) in
		//	for now we create the an empty collection view controller
		var collectionViewController = CollectionViewController()
		//	boxes all of the items and adds them to the collection view controller
		collectionViewController.items = items.map { Box($0) }
		//	configures each cell using the given render method, using the cell and the relevant unboxed item
		collectionViewController.configureCell = { cell, obj in
			if let boxed = obj as? Box<A> {
				return render(cell, boxed.unbox)
			}
			return cell
		}
		//	when the collection view controller has finished it call the callback with the selected (unboxed) item
		collectionViewController.callback = { x in
			if let boxed = x as? Box<A> {
				callback(boxed.unbox)
			}
		}
		
		//	returns the create TableViewController
		return collectionViewController
	})
}

//	MARK: TableViewController Class

class CollectionViewController: UICollectionViewController {
	
	//	MARK: Internal Properties
	
	/**	Array of items to be displayed.	*/
	var items: NSArray = []
	/**	A completion block to be called back with selected item.	*/
	var callback: AnyObject -> () = { _ in () }
	/**	A block that configures a cell with the given object.	*/
	var configureCell: (UICollectionViewCell, AnyObject) -> UICollectionViewCell = { $0.0 }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
		let obj: AnyObject = items[indexPath.row]
		return configureCell(cell, obj)
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		//	when the user selects the cell we call back with the appropriate selected objec: AnyObjectt
		let obj: AnyObject = items[indexPath.row]
		callback(obj)
	}
}
//
//  TableViewController.swift
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
func tableViewController<A>(render: (UITableViewCell, A) -> UITableViewCell) -> ViewController<[A],A> {
	
	return ViewController(create: { (items: [A], callback: A -> ()) in
		//	creates the table view controller from the storyboard
		var myTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyTableViewController") as! TableViewController
		//	boxes all of the items and adds them to the table view controller
		myTableViewController.items = items.map { Box($0) }
		//	configures each cell using the given render method, using the cell and the relevant unboxed item
		myTableViewController.configureCell = { cell, obj in
			if let boxed = obj as? Box<A> {
				return render(cell, boxed.unbox)
			}
			return cell
		}
		//	when the table view controller has finished it call the callback with the selected (unboxed) item
		myTableViewController.callback = { x in
			if let boxed = x as? Box<A> {
				callback(boxed.unbox)
			}
		}
		
		//	returns the create TableViewController
		return myTableViewController
	})
}

//	MARK: TableViewController Class

class TableViewController: UITableViewController {
	
	//	MARK: Internal Properties
	
	/**	Array of items to be displayed.	*/
	var items: NSArray = []
	/**	A completion block to be called back with selected item.	*/
	var callback: AnyObject -> () = { _ in () }
	/**	A block that configures a cell with the given object.	*/
	var configureCell: (UITableViewCell, AnyObject) -> UITableViewCell = { $0.0 }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//	for a given cell we use the appropriate object to configure it
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
		let obj: AnyObject = items[indexPath.row]
		return configureCell(cell, obj)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		//	when the user selects the cell we call back with the appropriate selected object
		let obj: AnyObject = items[indexPath.row]
		callback(obj)
	}
}
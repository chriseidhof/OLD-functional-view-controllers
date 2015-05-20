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
		var myTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyTableViewController") as! TableViewController<Box<A>>
		//	boxes all of the items and adds them to the table view controller
		myTableViewController.items = items.map { Box($0) }
		//	configures each cell using the given render method, using the cell and the relevant unboxed item
		myTableViewController.configureCell = { cell, boxed in
			return render(cell, boxed.unbox)
		}
		//	when the table view controller has finished it call the callback with the selected (unboxed) item
		myTableViewController.callback = { boxed in
			callback(boxed.unbox)
		}
		
		//	returns the create TableViewController
		return myTableViewController
	})
}

//	MARK: TableViewController Class

class TableViewController<A>: UITableViewController {
	/**	Array of items to be displayed.	*/
	var items = [A]()
	/**	A completion call back that takes the selected item*/
	var callback: A -> () = { _ in () }
	var configureCell: (UITableViewCell, A) -> UITableViewCell = { $0.0 }
	
	override func viewDidLoad() {
		println("load")
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
		var obj = items[indexPath.row]
		return configureCell(cell, obj)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var obj = items[indexPath.row]
		callback(obj)
	}
}
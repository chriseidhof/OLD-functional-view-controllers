//
//  TableViewController.swift
//  FunctionalViewControllers
//
//  Created by James Valaitis on 20/05/2015.
//  Copyright (c) 2015 Chris Eidhof. All rights reserved.
//

import UIKit

func tableViewController<A>(render: (UITableViewCell, A) -> UITableViewCell) -> ViewController<[A],A> {
	
	return ViewController(create: { (items: [A], callback: A -> ()) -> UIViewController  in
		var myTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MyTableViewController") as! TableViewController
		myTableViewController.items = items.map { Box($0) }
		myTableViewController.configureCell = { cell, obj in
			if let boxed = obj as? Box<A> {
				return render(cell, boxed.unbox)
			}
			return cell
		}
		myTableViewController.callback = { x in
			if let boxed = x as? Box<A> {
				callback(boxed.unbox)
			}
		}
		return myTableViewController
	})
}

class TableViewController: UITableViewController {
	var items: NSArray = []
	var callback: AnyObject -> () = { _ in () }
	var configureCell: (UITableViewCell, AnyObject) -> UITableViewCell = { $0.0 }
	
	override func viewDidLoad() {
		println("load")
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
		var obj: AnyObject = items[indexPath.row]
		return configureCell(cell, obj)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		var obj: AnyObject = items[indexPath.row]
		callback(obj)
	}
}
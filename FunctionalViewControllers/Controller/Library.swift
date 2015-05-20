//
//  ViewController.swift
//  FunctionalViewControllers
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

//	MARK: Box Class

public class Box<T> {
    public let unbox: T
    public init(_ value: T) {
		self.unbox = value
	}
}

//	MARK: Internal Functions

/**
	Maps a ViewController with a callback that takes B to a ViewController with a callback that takes C.
	
	:param:	vc		The ViewController to be mapped.
	:param:	f		The function responsible for mapping B to C.

	:returns:		A ViewController with a callback that takes C mapped from the given vc.
 */
func map<A,B,C>(vc: ViewController<A,B>, f: B -> C) -> ViewController<A,C> {
	
    return ViewController { x, callback in
        return vc.create(x) {
			//	use f to map B to C
            callback(f($0))
        }
    }
}

/**
	Maps a NavigationController with a callback B to a NavigationController with a callback that takes C.

	:param:	navCon	The NavigationController to be mapped.
	:param:	f		The function responsible for mapping B to C.

	:returns:		A NavigationController with a callback that takes C mapped from the given navCon.
*/
func map<A,B,C>(navCon: NavigationController<A,B>, f: B -> C) -> NavigationController<A,C> {
    return NavigationController { x, callback in
        return navCon.create(x) { (y, nc) in
			//	use f to map B to C
            callback(f(y), nc)
        }
    }
}

//	MARK: Controller Structs

struct ViewController<A,B> {
	/**	A function which will create a UIViewController with the given initial A, and a completion callback which take B. */
    let create: (A, B -> ()) -> UIViewController
}

struct NavigationController<A,B> {
	/**	A function which will create a UINavigation with the given initial A, and a completion callback which take B and another UINavigationController. */
    let create: (A, (B, UINavigationController) -> ()) -> UINavigationController
}

//	MARK: NavigationController Extension

extension NavigationController {
	/**
		Maps current NaviationController with a callback B to a NavigationController with a callback that takes C.
	
		:param:	f		The function responsible for mapping B to C.
		
		:returns:		A NavigationController with a callback that takes C.
	*/
    func map<C>(f: B -> C) -> NavigationController<A,C> {
        return NavigationController<A, C> { x, callback in
            return self.create(x) { (y, nc) in
                callback(f(y), nc)
            }
        }
    }
}

/**
	Convenience function that will return a UINavigationController with it's initial value of A, and it's completion callback.

	:param:	nc				The NavigationController used to create the UINavigationController.
	:param:	initialValue	The initial value used to create the UINavigationController.
	:param:	finish			A block to be called when the return UINavigationController is finished.
 */
func run<A,B>(nc: NavigationController<A,B>, initialValue: A, finish: B -> ()) -> UINavigationController {
	//	create the UINavigationController with the given initial value, and call it's completion when it is finished
    return nc.create(initialValue) { b, _ in
        finish(b)
    }
}

/**
	Creates a NavigationController with ViewController as it's root view controller.

	:param:	vc			The ViewController that create the root UIViewController.

	:returns:			A NavigationController that will create a UINavigationController with vc's UIViewController as it's root view controller.
 */
func rootViewController<A,B>(vc: ViewController<A,B>) -> NavigationController<A,B> {
    return NavigationController { initial, callback in
        let navController = UINavigationController()
		//	create a view controller when when it finishes calls the navigation controller's completion callback
        let rootController = vc.create(initial, { callback($0, navController) } )
        navController.viewControllers = [rootController]
        return navController
    }
}

//	MARK: Operator Overloading

infix operator >>> { associativity right }

func >>><A,B,C>(l: NavigationController<A,B>, r: ViewController<B,C>) -> NavigationController<A,C> {
    return NavigationController { x, callback in
        let nc = l.create(x, { b, nc in
            let rvc = r.create(b, { c in
                callback(c, nc)
            })
            nc.pushViewController(rvc, animated: true)
        })
        return nc
    }
}

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


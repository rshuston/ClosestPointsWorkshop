//
//  AppUtils.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/4/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class AppUtils: NSObject {

    class func appDelegate() -> AppDelegate? {
        return NSApplication.shared().delegate as? AppDelegate
    }

    class func appViewController() -> ViewController? {
        // Important Note:
        // Access to the contentViewController doesn't resolve until the app has finished
        // loading. If you try accessing it in a viewDidLoad() method, it will resolve to
        // nil.
        return NSApplication.shared().mainWindow?.contentViewController as? ViewController
    }

}

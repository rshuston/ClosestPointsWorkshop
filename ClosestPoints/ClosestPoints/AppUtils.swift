//
//  AppUtils.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/4/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class AppUtils: NSObject {

    // MARK: - Cocoa utilities

    // Return reference to the application delegate
    class func appDelegate() -> AppDelegate? {
        return NSApplication.shared().delegate as? AppDelegate
    }

    // Return reference to the application's main view controller
    class func appViewController() -> ViewController? {
        // Important Note:
        // Access to the contentViewController doesn't resolve until the app has finished
        // loading. If you try accessing it in a viewDidLoad() method, it will resolve to
        // nil.
        return NSApplication.shared().mainWindow?.contentViewController as? ViewController
    }

    // Convert an NSPoint from main window coordinates to local view coordinates
    class func convertWindowNSPoint(point: NSPoint, forView: NSView) -> NSPoint {
        return forView.convert(point, from: nil)  // nil = convert from window coordinates
    }

    // MARK: - General utilities

    // Determine if an NSPoint is on another NSPoint within a given margin
    class func IsNSPoint(point: NSPoint, onNSPoint: NSPoint, withMargin: CGFloat) -> Bool {
        var result = false

        if withMargin >= 0 {
            let dx = point.x - onNSPoint.x
            let dy = point.y - onNSPoint.y
            let sqDist = dx * dx + dy * dy
            let sqMargin = withMargin * withMargin
            if sqDist <= sqMargin {
                result = true
            }
        }

        return result
    }

    class func PinNSPoint(point: NSPoint, toNSRect: NSRect, withMargin: CGFloat) -> NSPoint {
        var pinnedPoint = point

        let insetRect = NSInsetRect(toNSRect, withMargin, withMargin)
        let xMin = insetRect.origin.x
        let xMax = insetRect.origin.x + insetRect.size.width
        let yMin = insetRect.origin.y
        let yMax = insetRect.origin.y + insetRect.size.height
        if pinnedPoint.x < xMin {
            pinnedPoint.x = xMin
        } else if pinnedPoint.x > xMax {
            pinnedPoint.x = xMax
        }
        if pinnedPoint.y < yMin {
            pinnedPoint.y = yMin
        } else if pinnedPoint.y > yMax {
            pinnedPoint.y = yMax
        }

        return pinnedPoint
    }

}

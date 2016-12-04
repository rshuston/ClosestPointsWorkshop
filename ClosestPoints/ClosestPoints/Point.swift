//
//  Point.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Point: NSObject {

    var x: CGFloat
    var y: CGFloat

    var xBackRef: AnyObject?
    var yBackRef: AnyObject?

    init(x: CGFloat, y: CGFloat)
    {
        self.x = x
        self.y = y
    }

    convenience init(withNSPoint: NSPoint) {
        self.init(x: withNSPoint.x, y: withNSPoint.y)
    }

    func getAsNSPoint() -> NSPoint {
        return NSPoint(x: x, y: y)
    }
    
}

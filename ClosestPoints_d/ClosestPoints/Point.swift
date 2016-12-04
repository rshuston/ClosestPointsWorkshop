//
//  Point.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Point: NSObject {

    var p: NSPoint

    init(x: CGFloat, y: CGFloat)
    {
        p = NSPoint(x: x, y: y)
    }
    
}

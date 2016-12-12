//
//  Point.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Point: NSObject {

    // Note:
    //
    // We use a class for Point instead of just using NSPoint because we need Points to
    // to be a reference types. NSPoint, which is typealiased from CGPoint, is a struct,
    // which is a value type.
    //
    // (Eewww! A comment! How untrendy! The horror of it all! Whaah! What can it mean?)

    var x: CGFloat
    var y: CGFloat

    var highlighted: Bool

    init(x: CGFloat, y: CGFloat)
    {
        self.x = x
        self.y = y
        
        self.highlighted = false
    }

    convenience init(withNSPoint: NSPoint) {
        self.init(x: withNSPoint.x, y: withNSPoint.y)
    }

    func getAsNSPoint() -> NSPoint {
        return NSPoint(x: x, y: y)
    }
    
}

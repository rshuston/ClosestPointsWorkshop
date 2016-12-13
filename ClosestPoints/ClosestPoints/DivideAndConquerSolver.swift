//
//  DivideAndConquerSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class DivideAndConquerSolver: Solver {

    override func findClosestPoints(points: [Point],
                                    monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                    completion: (((Point, Point)?) -> Void)) {
        var checkRect: NSRect
        var closestPoints: (Point, Point)?
        var keepRunning = true

        if points.count == 2 {
            closestPoints = (points[0], points[1])
            checkRect = AppUtils.NSRectFromNSPoints(pt1: points[0].getAsNSPoint(), pt2: points[1].getAsNSPoint())
            keepRunning = monitor?(checkRect, closestPoints!, closestPoints) ?? true
        } else if points.count > 2 {
        }

        completion(closestPoints)
    }

}

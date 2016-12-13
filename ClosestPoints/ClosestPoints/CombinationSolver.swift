//
//  CombinationSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class CombinationSolver: Solver {

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
            var smallestDistSquared: CGFloat = CGFloat.greatestFiniteMagnitude
            let count = points.count
            for ptA_index in 0..<count {
                let ptA = points[ptA_index]
                for ptB_index in (ptA_index+1)..<count {
                    let ptB = points[ptB_index]
                    let dx = ptB.x - ptA.x
                    let dy = ptB.y - ptA.y
                    let dist_sq = dx * dx + dy * dy
                    if dist_sq < smallestDistSquared {
                        smallestDistSquared = dist_sq
                        closestPoints = (ptA, ptB)
                    }
                    checkRect = AppUtils.NSRectFromNSPoints(pt1: ptA.getAsNSPoint(), pt2: ptB.getAsNSPoint())
                    keepRunning = monitor?(checkRect, (ptA, ptB), closestPoints) ?? true
                    if keepRunning == false {
                        break
                    }
                }
                if keepRunning == false {
                    break
                }
            }
        }

        completion(closestPoints)
    }

}

//
//  SolutionEngine.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/3/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class SolutionEngine: NSObject {

    func findClosestPoints_NaiveCombination(points: [Point],
                                            monitor: (((Point, Point)?) -> Void)?,
                                            completion: (((Point, Point)?) -> Void)) {
        var closestPoints: (Point, Point)?
        
        if points.count == 2 {
            closestPoints = (points[0], points[1])
            monitor?(closestPoints)
        } else if points.count > 2 {
            var smallestDist_sq: CGFloat = CGFloat.greatestFiniteMagnitude
            for ptA in points {
                for ptB in points {
                    if ptB != ptA {
                        let dx = ptB.x - ptA.x
                        let dy = ptB.y - ptA.y
                        let dist_sq = dx * dx + dy * dy
                        if dist_sq < smallestDist_sq {
                            smallestDist_sq = dist_sq
                            closestPoints = (ptA, ptB)
                        }
                        monitor?((ptA, ptB))
                    }
                }
            }
        }

        completion(closestPoints)
    }

}

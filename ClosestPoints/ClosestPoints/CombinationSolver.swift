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
                                    monitor: (((Point, Point), (Point, Point)?) -> Void)?,
                                    completion: (((Point, Point)?) -> Void)) {
        var closestPoints: (Point, Point)?

        if points.count == 2 {
            closestPoints = (points[0], points[1])
            monitor?(closestPoints!, closestPoints)
        } else if points.count > 2 {
            var smallestDist_sq: CGFloat = CGFloat.greatestFiniteMagnitude
            let count = points.count
            for ptA_index in 0..<count {
                let ptA = points[ptA_index]
                for ptB_index in (ptA_index+1)..<count {
                    let ptB = points[ptB_index]
                    let dx = ptB.x - ptA.x
                    let dy = ptB.y - ptA.y
                    let dist_sq = dx * dx + dy * dy
                    if dist_sq < smallestDist_sq {
                        smallestDist_sq = dist_sq
                        closestPoints = (ptA, ptB)
                    }
                    monitor?((ptA, ptB), closestPoints)
                }
            }
        }

        completion(closestPoints)
    }

}

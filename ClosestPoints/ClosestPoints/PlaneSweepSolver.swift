//
//  PlaneSweepSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlaneSweepSolver: Solver {

    class SolutionCarryOn {
        var checkRect: NSRect?
        var checkPoints: (Point, Point)?
        var closestPoints: (Point, Point)?
        var monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?

        func runMonitor() -> Bool {
            return monitor?(checkRect, checkPoints, closestPoints) ?? true
        }
    }

    override func findClosestPoints(points: [Point],
                                    monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                    completion: (((Point, Point)?) -> Void)) {
        let solutionCarryOn = SolutionCarryOn()
        
        var keepRunning = true

        if points.count >= 2 {
            let sortedPoints = points.sorted(by: { (lhs: Point, rhs: Point) -> Bool in
                return lhs.x <= rhs.x
            })
            let N = sortedPoints.count
            var distanceSquared = squaredEuclideanDistance(sortedPoints[0], sortedPoints[1])
            solutionCarryOn.checkRect = AppUtils.NSRectFromNSPoints(pt1: sortedPoints[0].getAsNSPoint(), pt2: sortedPoints[1].getAsNSPoint())
            solutionCarryOn.checkPoints = (sortedPoints[0], sortedPoints[1])
            solutionCarryOn.closestPoints = (sortedPoints[0], sortedPoints[1])
            solutionCarryOn.monitor = monitor
            keepRunning = solutionCarryOn.runMonitor()
            if N > 2 && keepRunning {
                for index in 2..<N {
                    let checkPoint = sortedPoints[index]
                    let matchDistance = sqrt(distanceSquared)
                    solutionCarryOn.checkRect = NSRect(x: checkPoint.x - matchDistance,
                                                       y: checkPoint.y - matchDistance,
                                                       width: matchDistance,
                                                       height: 2 * matchDistance)
                    let matchedPoints = groupPoints(points: sortedPoints, forIndex: index, withinDistance: matchDistance) // Results are in reverse order from sortedPoints[]
                    let result = findClosesPointIndexToFirst(points: matchedPoints,
                                                             withinDistanceSquared: distanceSquared,
                                                             withCarryOn: solutionCarryOn)
                    if result.1 < distanceSquared {
                        distanceSquared = result.1
                        solutionCarryOn.closestPoints = (checkPoint, matchedPoints[result.0])
                    }
                    solutionCarryOn.checkPoints = nil
                    keepRunning = solutionCarryOn.runMonitor()
                    if !keepRunning {
                        break
                    }
                }
            }
        }

        completion(solutionCarryOn.closestPoints)
    }

    internal func squaredEuclideanDistance(_ pt1: Point, _ pt2: Point) -> CGFloat {
        let dx = pt2.x - pt1.x
        let dy = pt2.y - pt1.y
        return dx * dx + dy * dy
    }

    internal func groupPoints(points: [Point], forIndex: Int, withinDistance: CGFloat) -> [Point] {
        var matchedPoints: [Point] = [points[forIndex]]

        for index in (0..<forIndex).reversed() {
            let dx = points[forIndex].x - points[index].x // points[] is sorted by x, so abs() not needed
            if dx <= withinDistance {
                let dy = abs(points[forIndex].y - points[index].y)
                if dy <= withinDistance {
                    matchedPoints.append(points[index])
                }
            } else {
                break
            }
        }

        return matchedPoints
    }

    internal func findClosesPointIndexToFirst(points: [Point], withinDistanceSquared: CGFloat, withCarryOn: SolutionCarryOn) -> (Int, CGFloat) {
        var keepRunning = true
        var found = (0, withinDistanceSquared)
        for index in 1..<points.count {
            withCarryOn.checkPoints = (points[index], points[0])
            let distanceSquared = squaredEuclideanDistance(points[index], points[0])
            if distanceSquared < found.1 {
                found = (index, distanceSquared)
            }
            keepRunning = withCarryOn.runMonitor()
            if !keepRunning {
                break
            }

        }
        return found
    }

}

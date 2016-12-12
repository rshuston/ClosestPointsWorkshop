//
//  PlaneSweepSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class PlaneSweepSolver: Solver {

    override func findClosestPoints(points: [Point],
                                    monitor: ((NSRect, (Point, Point), (Point, Point)?) -> Bool)?,
                                    completion: (((Point, Point)?) -> Void)) {
        var checkRect: NSRect
        var closestPoints: (Point, Point)?
        var keepRunning = true

        if points.count >= 2 {
            let sortedPoints = points.sorted(by: { (lhs: Point, rhs: Point) -> Bool in
                return lhs.x <= rhs.x
            })
            let N = sortedPoints.count
            var distanceSquared = squaredEuclideanDistance(sortedPoints[0], sortedPoints[1])
            closestPoints = (sortedPoints[0], sortedPoints[1])
            checkRect = AppUtils.NSRectFromNSPoints(pt1: sortedPoints[0].getAsNSPoint(), pt2: sortedPoints[1].getAsNSPoint())
            keepRunning = monitor?(checkRect, closestPoints!, closestPoints) ?? true
            if N > 2 && keepRunning {
                for index in 2..<N {
                    let checkPoint = sortedPoints[index]
                    let matchDistance = sqrt(distanceSquared)
                    checkRect = NSRect(x: checkPoint.x - matchDistance,
                                       y: checkPoint.y - matchDistance,
                                       width: matchDistance,
                                       height: 2 * matchDistance)
                    let matchedPoints = groupPoints(points: sortedPoints, forIndex: index, withinDistance: matchDistance) // Results are in reverse order from sortedPoints[]
                    let result = findClosesPointIndexToFirst(points: matchedPoints, withinDistanceSquared: distanceSquared)
                    if result.1 < distanceSquared {
                        distanceSquared = result.1
                        closestPoints = (checkPoint, matchedPoints[result.0])
                    }
                    keepRunning = monitor?(checkRect, closestPoints!, closestPoints) ?? true
                    if !keepRunning {
                        break
                    }
                }
            }
        }

        completion(closestPoints)
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
                matchedPoints.append(points[index])
            } else {
                break
            }
        }

        return matchedPoints
    }

    internal func findClosesPointIndexToFirst(points: [Point], withinDistanceSquared: CGFloat) -> (Int, CGFloat) {
        var found = (0, withinDistanceSquared)
        for index in 1..<points.count {
            let distanceSquared = squaredEuclideanDistance(points[index], points[0])
            if distanceSquared < found.1 {
                found = (index, distanceSquared)
            }
        }
        return found
    }

}

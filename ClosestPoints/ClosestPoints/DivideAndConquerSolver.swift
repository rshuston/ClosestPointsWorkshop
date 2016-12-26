//
//  DivideAndConquerSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class DivideAndConquerSolver: Solver {

    internal let maxSimpleRegionSize = 5

    struct PointRegion {
        var lower: Int  // Lower index into points array, -1 if not defined
        var upper: Int  // Upper index into points array, -1 if not defined
    }

    struct PointPairAndDistance {
        var pointPair: (Point, Point)
        var distanceSquared: CGFloat
    }

    class SolutionCarryOn {
        var checkRect: NSRect?
        var checkPoints: (Point, Point)?
        var closestPoints: (Point, Point)?
        var monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?

        var closestDistanceSquared: CGFloat = CGFloat.greatestFiniteMagnitude

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

            solutionCarryOn.checkRect = AppUtils.NSRectFromNSPoints(pt1: points[0].getAsNSPoint(), pt2: points[1].getAsNSPoint())
            solutionCarryOn.checkPoints = (points[0], points[1])
            solutionCarryOn.closestPoints = (points[0], points[1])
            solutionCarryOn.closestDistanceSquared = squaredEuclideanDistance(points[0], points[1])
            solutionCarryOn.monitor = monitor
            keepRunning = solutionCarryOn.runMonitor()

            if N > 2 && keepRunning {
                let pointRegion = PointRegion(lower: 0, upper: N - 1)

                let result = findClosestPointsInRegion(points: sortedPoints, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

                solutionCarryOn.closestPoints = result?.pointPair
                solutionCarryOn.closestDistanceSquared = result?.distanceSquared ?? CGFloat.greatestFiniteMagnitude
            }
        }

        completion(solutionCarryOn.closestPoints)
    }

    internal func squaredEuclideanDistance(_ pt1: Point, _ pt2: Point) -> CGFloat {
        let dx = pt2.x - pt1.x
        let dy = pt2.y - pt1.y
        return dx * dx + dy * dy
    }

    internal func dividePointRegion(region: PointRegion) -> (PointRegion, PointRegion) {
        let midPoint = (region.upper - region.lower) / 2 + region.lower
        let lowerRegion = PointRegion(lower: region.lower, upper: midPoint)
        let upperRegion = PointRegion(lower: midPoint + 1, upper: region.upper)
        return (lowerRegion, upperRegion)
    }

    internal func findClosestPointInBorderRegions(points: [Point],
                                                  lowerRegion: PointRegion,
                                                  upperRegion: PointRegion,
                                                  withinAxisDistance: CGFloat) -> PointPairAndDistance? {
        var result: PointPairAndDistance?

        let midPt = points[lowerRegion.upper]

        for leftIdx in (lowerRegion.lower...lowerRegion.upper).reversed() {
            let leftPt = points[leftIdx]
            if midPt.x - leftPt.x > withinAxisDistance {
                break
            }
            for rightIdx in upperRegion.lower...upperRegion.upper {
                let rightPt = points[rightIdx]
                if rightPt.x - midPt.x > withinAxisDistance {
                    break
                }
                let dx = rightPt.x - leftPt.x
                let dy = rightPt.y - leftPt.y
                if abs(dx) <= withinAxisDistance && abs(dy) <= withinAxisDistance {
                    let dist_sq = dx * dx + dy * dy
                    if result == nil {
                        result = PointPairAndDistance(pointPair: (leftPt, rightPt),
                                                      distanceSquared: dist_sq)
                    } else if dist_sq < result!.distanceSquared {
                        result!.pointPair = (leftPt, rightPt)
                        result!.distanceSquared = dist_sq
                    }
                }
            }
        }

        return result
    }

    internal func findClosestPointsInSimpleRegion(points: [Point], pointRegion: PointRegion) -> PointPairAndDistance? {
        var result: PointPairAndDistance?

        let count = pointRegion.upper - pointRegion.lower + 1
        switch count {
        case 2:
            let pointPair = (points[pointRegion.lower], points[pointRegion.upper])
            let distanceSquared = squaredEuclideanDistance(points[pointRegion.lower], points[pointRegion.upper])
            result = PointPairAndDistance(pointPair: pointPair, distanceSquared: distanceSquared)
            break
        case 3:
            // Three points is simple enough to solve directly
            let ptA = points[pointRegion.lower]
            let ptB = points[pointRegion.lower + 1]
            let ptC = points[pointRegion.upper]
            let distAB_sq = squaredEuclideanDistance(ptA, ptB)
            let distAC_sq = squaredEuclideanDistance(ptA, ptC)
            let distBC_sq = squaredEuclideanDistance(ptB, ptC)
            let pointPair: (Point, Point)
            let distanceSquared: CGFloat
            if distAB_sq <= distAC_sq && distAB_sq <= distBC_sq {
                pointPair = (ptA, ptB)
                distanceSquared = distAB_sq
            } else if distAC_sq <= distAB_sq && distAC_sq <= distBC_sq {
                pointPair = (ptA, ptC)
                distanceSquared = distAC_sq
            } else {
                pointPair = (ptB, ptC)
                distanceSquared = distBC_sq
            }
            result = PointPairAndDistance(pointPair: pointPair, distanceSquared: distanceSquared)
            break
        default:
            // Use simple combinatorial search
            for ptA_index in pointRegion.lower..<pointRegion.upper {
                let ptA = points[ptA_index]
                for ptB_index in (ptA_index+1)...pointRegion.upper {
                    let ptB = points[ptB_index]
                    let dist_sq = squaredEuclideanDistance(ptA, ptB)
                    if result == nil {
                        result = PointPairAndDistance(pointPair: (ptA, ptB),
                                                      distanceSquared: dist_sq)
                    } else if dist_sq < result!.distanceSquared {
                        result!.pointPair = (ptA, ptB)
                        result!.distanceSquared = dist_sq
                    }
                }
            }
            break
        }

        return result
    }

    // Recursive worker function to find closest points
    internal func findClosestPointsInRegion(points: [Point], pointRegion: PointRegion, withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
        var result: PointPairAndDistance? = nil

        let count = pointRegion.upper - pointRegion.lower + 1
        if count <= maxSimpleRegionSize {
            result = findClosestPointsInSimpleRegion(points: points, pointRegion: pointRegion)
        } else {
            let regions = dividePointRegion(region: pointRegion)
            let lowerRegion = regions.0
            let upperRegion = regions.1

            if let lowerResult = findClosestPointsInRegion(points: points, pointRegion: lowerRegion, withCarryOn: withCarryOn) {
                result = lowerResult
            }
            if let upperResult = findClosestPointsInRegion(points: points, pointRegion: upperRegion, withCarryOn: withCarryOn) {
                if result == nil {
                    result = upperResult
                } else {
                    if upperResult.distanceSquared < result!.distanceSquared {
                        result = upperResult
                    }
                }
            }
            let axisDistance: CGFloat
            if result != nil {
                axisDistance = sqrt(result!.distanceSquared)
            } else {
                axisDistance = CGFloat.greatestFiniteMagnitude
            }
            if let middleResult = findClosestPointInBorderRegions(points: points, lowerRegion: lowerRegion, upperRegion: upperRegion, withinAxisDistance: axisDistance) {
                if result == nil {
                    result = middleResult
                } else {
                    if middleResult.distanceSquared < result!.distanceSquared {
                        result = middleResult
                    }
                }
            }
        }

        return result
    }

}

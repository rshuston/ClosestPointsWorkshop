//
//  DivideAndConquerSolver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class DivideAndConquerSolver: Solver {

    var maxSimpleRegionSize = 7

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
        
        func monitorPointPair(pointPair: (Point, Point), distanceSquared: CGFloat) -> Bool {
            var keepRunning = true
            if monitor != nil {
                checkRect = AppUtils.NSRectFromNSPoints(pointPair.0.getAsNSPoint(), pointPair.1.getAsNSPoint())
                checkPoints = pointPair
                if distanceSquared < closestDistanceSquared {
                    closestDistanceSquared = distanceSquared
                    closestPoints = checkPoints
                }
                keepRunning = monitor!(checkRect, checkPoints, closestPoints)
            }
            return keepRunning
        }

        func monitorRectForPoint(point: Point, withAxisDistance: CGFloat) -> Bool {
            var keepRunning = true
            if monitor != nil {
                checkRect = NSRect(x: point.x - withAxisDistance,
                                   y: point.y - withAxisDistance,
                                   width: withAxisDistance,
                                   height: 2 * withAxisDistance)
                checkPoints = nil
                keepRunning = monitor!(checkRect, checkPoints, closestPoints)
            }
            return keepRunning
        }
    }
    
    override func findClosestPoints(points: [Point],
                                    monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                                    completion: (((Point, Point)?) -> Void)) {
        var closestPoints: (Point, Point)?

        let solutionCarryOn = SolutionCarryOn()

        solutionCarryOn.monitor = monitor

        if points.count >= 2 {
            let sortedPoints = points.sorted(by: { (lhs: Point, rhs: Point) -> Bool in
                return lhs.x <= rhs.x
            })
            let N = sortedPoints.count
            let pointRegion = PointRegion(lower: 0, upper: N - 1)
            let result = findClosestPointsInRegion(points: sortedPoints, pointRegion: pointRegion, withCarryOn: solutionCarryOn)
            closestPoints = result?.pointPair
        }

        completion(closestPoints)
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

    internal func findClosestPointsInSimpleRegion(points: [Point],
                                                  pointRegion: PointRegion,
                                                  withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
        var result: PointPairAndDistance?

        let count = pointRegion.upper - pointRegion.lower + 1
        switch count {
        case 2:
            let pointPair = (points[pointRegion.lower], points[pointRegion.upper])
            let distanceSquared = squaredEuclideanDistance(points[pointRegion.lower], points[pointRegion.upper])
            result = PointPairAndDistance(pointPair: pointPair, distanceSquared: distanceSquared)
            _ = withCarryOn.monitorPointPair(pointPair: pointPair, distanceSquared: distanceSquared)
            break
        default:
            // Use simple combinatorial search
            var keepRunning = true
            for ptA_index in pointRegion.lower..<pointRegion.upper {
                let ptA = points[ptA_index]
                for ptB_index in (ptA_index+1)...pointRegion.upper {
                    let ptB = points[ptB_index]
                    let distanceSquared = squaredEuclideanDistance(ptA, ptB)
                    if result == nil {
                        result = PointPairAndDistance(pointPair: (ptA, ptB),
                                                      distanceSquared: distanceSquared)
                    } else if distanceSquared < result!.distanceSquared {
                        result!.pointPair = (ptA, ptB)
                        result!.distanceSquared = distanceSquared
                    }
                    keepRunning = withCarryOn.monitorPointPair(pointPair: result!.pointPair, distanceSquared: distanceSquared)
                    if !keepRunning {
                        break
                    }
                }
                if !keepRunning {
                    break
                }
            }
            break
        }

        return result
    }

    internal func findClosestPointInBorderRegions(points: [Point],
                                                  lowerRegion: PointRegion,
                                                  upperRegion: PointRegion,
                                                  withinAxisDistance: CGFloat,
                                                  withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
        var result: PointPairAndDistance?
        var keepRunning = true

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
                    let distanceSquared = dx * dx + dy * dy
                    if result == nil {
                        result = PointPairAndDistance(pointPair: (leftPt, rightPt),
                                                      distanceSquared: distanceSquared)
                    } else if distanceSquared < result!.distanceSquared {
                        result!.pointPair = (leftPt, rightPt)
                        result!.distanceSquared = distanceSquared
                    }
                    keepRunning = withCarryOn.monitorPointPair(pointPair: result!.pointPair, distanceSquared: distanceSquared)
                } else {
                    keepRunning = withCarryOn.monitorRectForPoint(point: leftPt, withAxisDistance: withinAxisDistance)
                }
                if !keepRunning {
                    break
                }
            }
            if !keepRunning {
                break
            }
        }

        return result
    }

    // Recursive worker function to find closest points
    internal func findClosestPointsInRegion(points: [Point],
                                            pointRegion: PointRegion,
                                            withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
        var result: PointPairAndDistance? = nil

        let count = pointRegion.upper - pointRegion.lower + 1
        if count <= maxSimpleRegionSize {
            result = findClosestPointsInSimpleRegion(points: points, pointRegion: pointRegion, withCarryOn: withCarryOn)
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
            if let middleResult = findClosestPointInBorderRegions(points: points, lowerRegion: lowerRegion, upperRegion: upperRegion, withinAxisDistance: axisDistance, withCarryOn: withCarryOn) {
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

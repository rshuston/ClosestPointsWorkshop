//
//  DivideAndConquerSolverTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

import PDLTestBench

@testable import ClosestPoints

class DivideAndConquerSolverTests: XCTestCase {

    // MARK: - Internal function tests

    func test_squaredEuclideanDistance_FindsHorizontalDistance() {
        let pt1 = Point(x: 0, y: 1)
        let pt2 = Point(x: 2, y: 1)
        let subject = DivideAndConquerSolver()

        let distanceSquared = subject.squaredEuclideanDistance(pt1, pt2)

        XCTAssertEqual(distanceSquared, 4)
    }

    func test_squaredEuclideanDistance_FindsVerticalDistance() {
        let pt1 = Point(x: 1, y: 1)
        let pt2 = Point(x: 1, y: 3)
        let subject = DivideAndConquerSolver()

        let distanceSquared = subject.squaredEuclideanDistance(pt1, pt2)

        XCTAssertEqual(distanceSquared, 4)
    }

    func test_squaredEuclideanDistance_FindsDiagonalDistance() {
        let pt1 = Point(x: -1, y: -1)
        let pt2 = Point(x: 2, y: 2)
        let subject = DivideAndConquerSolver()

        let distanceSquared = subject.squaredEuclideanDistance(pt1, pt2)
        
        XCTAssertEqual(distanceSquared, 18)
    }

    func test_dividePointRegion_DividesZeroBasedRegion() {
        let region = DivideAndConquerSolver.PointRegion(lower: 0, upper: 1)
        let subject = DivideAndConquerSolver()

        let result = subject.dividePointRegion(region: region)

        let lowerRegion = result.0
        let upperRegion = result.1

        XCTAssertEqual(lowerRegion.lower, 0)
        XCTAssertEqual(lowerRegion.upper, 0)
        XCTAssertEqual(upperRegion.lower, 1)
        XCTAssertEqual(upperRegion.upper, 1)
    }

    func test_dividePointRegion_DividesNonZeroBasedRegion() {
        let region = DivideAndConquerSolver.PointRegion(lower: 3, upper: 4)
        let subject = DivideAndConquerSolver()

        let result = subject.dividePointRegion(region: region)

        let lowerRegion = result.0
        let upperRegion = result.1

        XCTAssertEqual(lowerRegion.lower, 3)
        XCTAssertEqual(lowerRegion.upper, 3)
        XCTAssertEqual(upperRegion.lower, 4)
        XCTAssertEqual(upperRegion.upper, 4)
    }

    func test_dividePointRegion_DividesArbitraryRegion() {
        let region = DivideAndConquerSolver.PointRegion(lower: 3, upper: 9)
        let subject = DivideAndConquerSolver()

        let result = subject.dividePointRegion(region: region)

        let lowerRegion = result.0
        let upperRegion = result.1

        XCTAssertEqual(lowerRegion.lower, 3)
        XCTAssertEqual(lowerRegion.upper, 6)
        XCTAssertEqual(upperRegion.lower, 7)
        XCTAssertEqual(upperRegion.upper, 9)
    }

    func test_findClosestPointsInSimpleRegion_FindsClosestPointsForTwoPointRegion() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 1) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 1)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 1)
            XCTAssertEqual(result!.pointPair.0, points[0])
            XCTAssertEqual(result!.pointPair.1, points[1])
        }
    }

    // XXXXXX
    func test_findClosestPointsInSimpleRegion_CallsMonitorClosureForTwoPointRegion() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 1) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 1)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        var monitorCount = 0
        solutionCarryOn.monitor = {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            return true
        }

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        XCTAssertNotEqual(monitorCount, 0)
    }

    func test_findClosestPointsInSimpleRegion_FindsClosestPointsForThreePointRegion_1() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 1),
                       Point(x: 3, y: 2) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 1)
            XCTAssertEqual(result!.pointPair.0, points[0])
            XCTAssertEqual(result!.pointPair.1, points[1])
        }
    }

    func test_findClosestPointsInSimpleRegion_FindsClosestPointsForThreePointRegion_2() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 2),
                       Point(x: 3, y: 2) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 1)
            XCTAssertEqual(result!.pointPair.0, points[1])
            XCTAssertEqual(result!.pointPair.1, points[2])
        }
    }

    func test_findClosestPointsInSimpleRegion_FindsClosestPointsForThreePointRegion_3() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 100),
                       Point(x: 3, y: 2) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 5)
            XCTAssertEqual(result!.pointPair.0, points[0])
            XCTAssertEqual(result!.pointPair.1, points[2])
        }
    }

    // XXXXXX
    func test_findClosestPointsInSimpleRegion_CallsMonitoClosureForThreePointRegion() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 1),
                       Point(x: 3, y: 2) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        var monitorCount = 0
        solutionCarryOn.monitor = {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            return true
        }

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        XCTAssertNotEqual(monitorCount, 0)
    }

    func test_findClosestPointsInSimpleRegion_FindsClosestPointsForFivePointRegion() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 2),
                       Point(x: 3, y: 100),
                       Point(x: 4, y: 100),
                       Point(x: 5, y: 5) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 4)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInSimpleRegion(points: points,
                                                             pointRegion: pointRegion,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 1)
            XCTAssertEqual(result!.pointPair.0, points[2])
            XCTAssertEqual(result!.pointPair.1, points[3])
        }
    }

    func test_findClosestPointInBorderRegions_FindsClosestPointsWithinDistanceForTrivialRegions() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 1) ]
        let lowerBorderRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 0)
        let upperBorderRegion = DivideAndConquerSolver.PointRegion(lower: 1, upper: 1)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointInBorderRegions(points: points,
                                                             lowerRegion: lowerBorderRegion,
                                                             upperRegion: upperBorderRegion,
                                                             withinAxisDistance: CGFloat.greatestFiniteMagnitude,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 1)
            XCTAssertEqual(result!.pointPair.0, points[0])
            XCTAssertEqual(result!.pointPair.1, points[1])
        }
    }

    func test_findClosestPointInBorderRegions_FindsClosestPointsAcrossBorder() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 3, y: 1),
                       Point(x: 5.45, y: 1),    // first of closest pair within border
            Point(x: 5.5, y: 1),     // first of closest pair across border
            Point(x: 5.75, y: 1),    // second of closest pair across border
            Point(x: 7, y: 1),
            Point(x: 9, y: 1) ]
        let lowerBorderRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 3)
        let upperBorderRegion = DivideAndConquerSolver.PointRegion(lower: 4, upper: 6)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointInBorderRegions(points: points,
                                                             lowerRegion: lowerBorderRegion,
                                                             upperRegion: upperBorderRegion,
                                                             withinAxisDistance: CGFloat.greatestFiniteMagnitude,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqualWithAccuracy(result!.distanceSquared, 0.0625, accuracy: 0.00001)
            XCTAssertEqual(result!.pointPair.0, points[3])
            XCTAssertEqual(result!.pointPair.1, points[4])
        }
    }

    func test_findClosestPointInBorderRegions_FindsClosestPointsForLinearPointSet() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 3, y: 2),
                       Point(x: 5, y: 3),   // first of closest pair
            Point(x: 7, y: 4),   // second of closest pair
            Point(x: 9, y: 5) ]
        let lowerBorderRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)
        let upperBorderRegion = DivideAndConquerSolver.PointRegion(lower: 3, upper: 4)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointInBorderRegions(points: points,
                                                             lowerRegion: lowerBorderRegion,
                                                             upperRegion: upperBorderRegion,
                                                             withinAxisDistance: CGFloat.greatestFiniteMagnitude,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 5)
            XCTAssertEqual(result!.pointPair.0, points[2])
            XCTAssertEqual(result!.pointPair.1, points[3])
        }
    }

    func test_findClosestPointInBorderRegions_FindsClosestPointsForLargePointRegions() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 3, y: 2),
                       Point(x: 4.1, y: 2),
                       Point(x: 4.2, y: 2),     // first of closest pair
            Point(x: 4.3, y: 20),
            Point(x: 4.4, y: 3),     // second of closest pair
            Point(x: 5, y: 4),
            Point(x: 6, y: 5) ]
        let lowerBorderRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 3)
        let upperBorderRegion = DivideAndConquerSolver.PointRegion(lower: 4, upper: 7)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointInBorderRegions(points: points,
                                                             lowerRegion: lowerBorderRegion,
                                                             upperRegion: upperBorderRegion,
                                                             withinAxisDistance: CGFloat.greatestFiniteMagnitude,
                                                             withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqualWithAccuracy(result!.distanceSquared, 1.04, accuracy: 0.00001)
            XCTAssertEqual(result!.pointPair.0, points[3])
            XCTAssertEqual(result!.pointPair.1, points[5])
        }
    }

    func test_findClosestPointInBorderRegions_RejectsPointsNotWithinAxisDistance() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 3, y: 2),
                       Point(x: 5, y: 3),   // first of closest pair
            Point(x: 7, y: 4),   // second of closest pair
            Point(x: 9, y: 5) ]
        let lowerBorderRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 2)
        let upperBorderRegion = DivideAndConquerSolver.PointRegion(lower: 3, upper: 4)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointInBorderRegions(points: points,
                                                             lowerRegion: lowerBorderRegion,
                                                             upperRegion: upperBorderRegion,
                                                             withinAxisDistance: 1,
                                                             withCarryOn: solutionCarryOn)
        
        XCTAssertNil(result)
    }

    func test_findClosestPointsInRegion_FindsClosestPointsForTrivialPointSet() {
        let points = [ Point(x: 1, y: 1),
                       Point(x: 2, y: 2) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 1)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = DivideAndConquerSolver()

        let result = subject.findClosestPointsInRegion(points: points, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 2)
            XCTAssertEqual(result!.pointPair.0, points[0])
            XCTAssertEqual(result!.pointPair.1, points[1])
        }
    }

    func test_findClosestPointsInRegion_FindsClosestPointsForASixPointSet() {
        let points = [ Point(x: 3, y: 15),
                       Point(x: 12, y: 26),
                       Point(x: 17, y: 21), // first of closest pair
                       Point(x: 21, y: 23), // second of closest pair
                       Point(x: 31, y: 17),
                       Point(x: 35, y: 25) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 5)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = SpyDivideAndConquerSolver()

        let result = subject.findClosestPointsInRegion(points: points, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 20)
            XCTAssertEqual(result!.pointPair.0, points[2])
            XCTAssertEqual(result!.pointPair.1, points[3])
        }

        // Expected solution breakdown:
        //
        // 1:    0 1 2 3 4 5
        // 2:  0 1 2  :  3 4 5
        // 3:       border
        //
        // 2 calls to findClosestPointsInSimpleRegion()
        // 1 calls to findClosestPointInBorderRegions()

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointsInSimpleRegion"), 2)
        let simpleReturn0 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn0?.distanceSquared, 50)
        XCTAssertEqual(simpleReturn0?.pointPair.0, points[1])
        XCTAssertEqual(simpleReturn0?.pointPair.1, points[2])
        let simpleReturn1 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 1) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn1?.distanceSquared, 80)
        XCTAssertEqual(simpleReturn1?.pointPair.0, points[4])
        XCTAssertEqual(simpleReturn1?.pointPair.1, points[5])

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointInBorderRegions"), 1)
        let borderParams0 = subject.recorder.getCallRecordFor("findClosestPointInBorderRegions", forInvocation: 0)
        let axisDistance = borderParams0?[3] as? CGFloat ?? 0
        XCTAssertEqual(axisDistance, sqrt(50))
        let borderReturn0 = subject.recorder.getReturnValueFor("findClosestPointInBorderRegions", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(borderReturn0?.distanceSquared, 20)
        XCTAssertEqual(borderReturn0?.pointPair.0, points[2])
        XCTAssertEqual(borderReturn0?.pointPair.1, points[3])
    }

    func test_findClosestPointsInRegion_FindsClosestPointsForASevenPointSet() {
        let points = [ Point(x: 3, y: 15),
                       Point(x: 15, y: 31),
                       Point(x: 17, y: 21), // first of closest pair
                       Point(x: 21, y: 23), // second of closest pair
                       Point(x: 29, y: 11),
                       Point(x: 31, y: 17),
                       Point(x: 35, y: 25) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 6)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = SpyDivideAndConquerSolver()

        let result = subject.findClosestPointsInRegion(points: points, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 20)
            XCTAssertEqual(result!.pointPair.0, points[2])
            XCTAssertEqual(result!.pointPair.1, points[3])
        }

        // Expected solution breakdown:
        //
        // 1:       0 1 2 3 4 5 6
        // 2:    0 1 2 3  :  4 5 6
        // 3:  0 1  :  2 3
        // 4:     border
        // 5:          border
        //
        // 3 calls to findClosestPointsInSimpleRegion()
        // 2 calls to findClosestPointInBorderRegions()

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointsInSimpleRegion"), 3)
        let simpleReturn0 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn0?.distanceSquared, 400)
        XCTAssertEqual(simpleReturn0?.pointPair.0, points[0])
        XCTAssertEqual(simpleReturn0?.pointPair.1, points[1])
        let simpleReturn1 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 1) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn1?.distanceSquared, 20)
        XCTAssertEqual(simpleReturn1?.pointPair.0, points[2])
        XCTAssertEqual(simpleReturn1?.pointPair.1, points[3])
        let simpleReturn2 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 2) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn2?.distanceSquared, 40)
        XCTAssertEqual(simpleReturn2?.pointPair.0, points[4])
        XCTAssertEqual(simpleReturn2?.pointPair.1, points[5])

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointInBorderRegions"), 2)
        var axisDistance: CGFloat
        let borderParams0 = subject.recorder.getCallRecordFor("findClosestPointInBorderRegions", forInvocation: 0)
        axisDistance = borderParams0?[3] as? CGFloat ?? 0
        XCTAssertEqual(axisDistance, sqrt(20))
        let borderReturn0 = subject.recorder.getReturnValueFor("findClosestPointInBorderRegions", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertNil(borderReturn0)
        let borderParams1 = subject.recorder.getCallRecordFor("findClosestPointInBorderRegions", forInvocation: 1)
        axisDistance = borderParams1?[3] as? CGFloat ?? 0
        XCTAssertEqual(axisDistance, sqrt(20))
        let borderReturn1 = subject.recorder.getReturnValueFor("findClosestPointInBorderRegions", forInvocation: 1) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertNil(borderReturn1)
    }

    func test_findClosestPointsInRegion_FindsClosestPointsForASevenPointSetForFivePointSimpleThreshold() {
        let points = [ Point(x: 3, y: 15),
                       Point(x: 15, y: 31),
                       Point(x: 17, y: 21), // first of closest pair
                       Point(x: 21, y: 23), // second of closest pair
                       Point(x: 29, y: 11),
                       Point(x: 31, y: 17),
                       Point(x: 35, y: 25) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 6)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = SpyDivideAndConquerSolver()

        subject.maxSimpleRegionSize = 5

        let result = subject.findClosestPointsInRegion(points: points, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 20)
            XCTAssertEqual(result!.pointPair.0, points[2])
            XCTAssertEqual(result!.pointPair.1, points[3])
        }

        // Expected solution breakdown:
        //
        // 1:    0 1 2 3 4 5 6
        // 2:  0 1 2 3  :  4 5 6
        // 3:         border
        //
        // 2 calls to findClosestPointsInSimpleRegion()
        // 1 calls to findClosestPointInBorderRegions()

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointsInSimpleRegion"), 2)
        let simpleReturn0 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn0?.distanceSquared, 20)
        XCTAssertEqual(simpleReturn0?.pointPair.0, points[2])
        XCTAssertEqual(simpleReturn0?.pointPair.1, points[3])
        let simpleReturn1 = subject.recorder.getReturnValueFor("findClosestPointsInSimpleRegion", forInvocation: 1) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertEqual(simpleReturn1?.distanceSquared, 40)
        XCTAssertEqual(simpleReturn1?.pointPair.0, points[4])
        XCTAssertEqual(simpleReturn1?.pointPair.1, points[5])

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointInBorderRegions"), 1)
        let borderReturn0 = subject.recorder.getReturnValueFor("findClosestPointInBorderRegions", forInvocation: 0) as? DivideAndConquerSolver.PointPairAndDistance
        XCTAssertNil(borderReturn0)
    }

    func test_findClosestPointsInRegion_FindsClosestPointsForAThirteenPointSet() {
        let points = [ Point(x: 3, y: 15),
                       Point(x: 5, y: 27),
                       Point(x: 7, y: 19),
                       Point(x: 11, y: 9),
                       Point(x: 13, y: 37),
                       Point(x: 15, y: 31),
                       Point(x: 17, y: 21),  // first of closest pair
                       Point(x: 21, y: 23),  // second of closest pair
                       Point(x: 25, y: 29),
                       Point(x: 29, y: 11),
                       Point(x: 31, y: 17),
                       Point(x: 33, y: 5),
                       Point(x: 35, y: 25) ]
        let pointRegion = DivideAndConquerSolver.PointRegion(lower: 0, upper: 12)

        let solutionCarryOn = DivideAndConquerSolver.SolutionCarryOn()

        let subject = SpyDivideAndConquerSolver()

        let result = subject.findClosestPointsInRegion(points: points, pointRegion: pointRegion, withCarryOn: solutionCarryOn)

        XCTAssertNotNil(result)
        if result != nil {
            XCTAssertEqual(result!.distanceSquared, 20)
            XCTAssertEqual(result!.pointPair.0, points[6])
            XCTAssertEqual(result!.pointPair.1, points[7])
        }

        // Expected solution breakdown:
        //
        // 1:          0 1 2 3 4 5 6 7 8 9 10 11 12
        // 2:        0 1 2 3 4 5 6  :  7 8 9 10 11 12
        // 3:    0 1 2 3  :  4 5 6     7 8 9  :  10 11 12
        // 4:  0 1  :  2 3
        // 5:    border
        // 6:          border               border
        // 7:                     border
        //
        // 5 calls to findClosestPointsInSimpleRegion()
        // 4 calls to findClosestPointInBorderRegions()

        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointsInSimpleRegion"), 5)
        XCTAssertEqual(subject.recorder.getCallCountFor("findClosestPointInBorderRegions"), 4)
    }

    // MARK: - findClosestPoints() tests

    func test_findClosestPoints_ReturnsNilForEmptyPointSet() {
        let points: [Point] = []
        let subject = DivideAndConquerSolver()

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNil(closestPoints)
            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_ReturnsNilForInsufficientPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 2))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNil(closestPoints)
            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_FindsClosestPointsForTrivialPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[0])
                XCTAssertEqual(closestPoints?.1, points[1])
            } else {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_CallsMonitorClosureForTrivialPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(checkRect)
            XCTAssertFalse(NSIsEmptyRect(checkRect!))

            XCTAssertNotNil(closestPointsSoFar)

            XCTAssertEqual(checkPoints?.0, closestPointsSoFar?.0)
            XCTAssertEqual(checkPoints?.1, closestPointsSoFar?.1)

            let listOrdered = (closestPointsSoFar?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPointsSoFar?.0, points[0])
                XCTAssertEqual(closestPointsSoFar?.1, points[1])
            } else {
                XCTAssertEqual(closestPointsSoFar?.0, points[1])
                XCTAssertEqual(closestPointsSoFar?.1, points[0])
            }

            return true
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 1)

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[0])
                XCTAssertEqual(closestPoints?.1, points[1])
            } else {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[0])
            }
            
            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_FindsClosestPointsForTrinaryPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 1))
        points.append(Point(x: 4, y: 5))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[2])
            } else {
                XCTAssertEqual(closestPoints?.0, points[2])
                XCTAssertEqual(closestPoints?.1, points[1])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_CallsMonitorClosureForTrinaryPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 1))
        points.append(Point(x: 4, y: 5))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            return true
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertNotEqual(monitorCount, 0)

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[2])
            } else {
                XCTAssertEqual(closestPoints?.0, points[2])
                XCTAssertEqual(closestPoints?.1, points[1])
            }

            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_CanAbortFromMonitorClosureForTrinaryPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 1))
        points.append(Point(x: 4, y: 5))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            return false
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 1)

            XCTAssertNotNil(closestPoints)

            XCTAssertEqual(closestPoints?.0, points[0])
            XCTAssertEqual(closestPoints?.1, points[2])

            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_FindsClosestPointsForMultiplePointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 10, y: 10))
        points.append(Point(x: 101, y: 101))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[3])
            } else {
                XCTAssertEqual(closestPoints?.0, points[3])
                XCTAssertEqual(closestPoints?.1, points[1])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_CallsMonitorClosureForForMultiplePointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 10, y: 10))
        points.append(Point(x: 101, y: 101))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkRect: NSRect?, checkPoints: (Point, Point)?, closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            return true
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertNotEqual(monitorCount, 0)

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[3])
            } else {
                XCTAssertEqual(closestPoints?.0, points[3])
                XCTAssertEqual(closestPoints?.1, points[1])
            }

            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_FindsClosestPointsForThirteenPointSet() {
        var points: [Point] = []
        let subject = DivideAndConquerSolver()

        points.append(Point(x: 31, y: 17))
        points.append(Point(x: 21, y: 23)) // first of closest pair
        points.append(Point(x: 3, y: 15))
        points.append(Point(x: 15, y: 31))
        points.append(Point(x: 35, y: 25))
        points.append(Point(x: 29, y: 11))
        points.append(Point(x: 17, y: 21)) // second of closest pair
        points.append(Point(x: 5, y: 27))
        points.append(Point(x: 11, y: 9))
        points.append(Point(x: 13, y: 37))
        points.append(Point(x: 7, y: 19))
        points.append(Point(x: 33, y: 5))
        points.append(Point(x: 25, y: 29))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[1])
                XCTAssertEqual(closestPoints?.1, points[6])
            } else {
                XCTAssertEqual(closestPoints?.0, points[6])
                XCTAssertEqual(closestPoints?.1, points[1])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    // MARK: - Mocks and Spies

    class SpyDivideAndConquerSolver : DivideAndConquerSolver {

        let recorder = FuncRecorder()

        internal override func findClosestPointInBorderRegions(points: [Point],
                                                      lowerRegion: PointRegion,
                                                      upperRegion: PointRegion,
                                                      withinAxisDistance: CGFloat,
                                                      withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
            recorder.recordCallFor("findClosestPointInBorderRegions", params: [points, lowerRegion, upperRegion, withinAxisDistance, withCarryOn])

            let returnValue = super.findClosestPointInBorderRegions(points: points, lowerRegion: lowerRegion, upperRegion: upperRegion, withinAxisDistance: withinAxisDistance, withCarryOn: withCarryOn)

            recorder.recordReturnFor("findClosestPointInBorderRegions", value: returnValue)

            return returnValue
        }

        internal override func findClosestPointsInSimpleRegion(points: [Point],
                                                               pointRegion: PointRegion,
                                                               withCarryOn: SolutionCarryOn) -> PointPairAndDistance? {
            recorder.recordCallFor("findClosestPointsInSimpleRegion", params: [points, pointRegion, withCarryOn])

            let returnValue = super.findClosestPointsInSimpleRegion(points: points, pointRegion: pointRegion, withCarryOn: withCarryOn)

            recorder.recordReturnFor("findClosestPointsInSimpleRegion", value: returnValue)

            return returnValue
        }

    }
}

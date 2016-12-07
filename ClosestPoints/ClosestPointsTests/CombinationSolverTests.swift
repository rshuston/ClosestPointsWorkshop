//
//  CombinationSolverTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import ClosestPoints

class CombinationSolverTests: XCTestCase {

    func test_findClosestPoints_ReturnsNilForEmptyPointSet() {
        let points: [Point] = []
        let subject = CombinationSolver()

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
        let subject = CombinationSolver()

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
        let subject = CombinationSolver()

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
        let subject = CombinationSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkPoints: (Point, Point), closestPointsSoFar: (Point, Point)?) -> Void in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            XCTAssertEqual(checkPoints.0, closestPointsSoFar?.0)
            XCTAssertEqual(checkPoints.1, closestPointsSoFar?.1)

            let listOrdered = (closestPointsSoFar?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPointsSoFar?.0, points[0])
                XCTAssertEqual(closestPointsSoFar?.1, points[1])
            } else {
                XCTAssertEqual(closestPointsSoFar?.0, points[1])
                XCTAssertEqual(closestPointsSoFar?.1, points[0])
            }
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
        let subject = CombinationSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[0])
                XCTAssertEqual(closestPoints?.1, points[2])
            } else {
                XCTAssertEqual(closestPoints?.0, points[2])
                XCTAssertEqual(closestPoints?.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_CallsMonitorClosureForTrinaryPointSet() {
        var points: [Point] = []
        let subject = CombinationSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkPoints: (Point, Point), closestPointsSoFar: (Point, Point)?) -> Void in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 3) // Combination (nCr) of 3C2 = 3

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints?.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints?.0, points[0])
                XCTAssertEqual(closestPoints?.1, points[2])
            } else {
                XCTAssertEqual(closestPoints?.0, points[2])
                XCTAssertEqual(closestPoints?.1, points[0])
            }

            completionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_FindsClosestPointsForMultiplePointSet() {
        var points: [Point] = []
        let subject = CombinationSolver()

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
        let subject = CombinationSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 10, y: 10))
        points.append(Point(x: 101, y: 101))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkPoints: (Point, Point), closestPointsSoFar: (Point, Point)?) -> Void in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 10) // Combination (nCr) of 5C2 = 10

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

}

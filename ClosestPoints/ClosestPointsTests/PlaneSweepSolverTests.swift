//
//  PlaneSweepSolverTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/11/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import ClosestPoints

class PlaneSweepSolverTests: XCTestCase {

    func test_findClosestPoints_ReturnsNilForEmptyPointSet() {
        let points: [Point] = []
        let subject = PlaneSweepSolver()

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
        let subject = PlaneSweepSolver()

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
        let subject = PlaneSweepSolver()

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
        let subject = PlaneSweepSolver()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints(points: points, monitor: {
            (checkRect: NSRect, checkPoints: (Point, Point), closestPointsSoFar: (Point, Point)?) -> Bool in
            monitorCount += 1

            XCTAssertNotNil(closestPointsSoFar)

            XCTAssertEqual(checkPoints.0, closestPointsSoFar?.0)
            XCTAssertEqual(checkPoints.1, closestPointsSoFar?.1)

            XCTAssertFalse(NSIsEmptyRect(checkRect))

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

}

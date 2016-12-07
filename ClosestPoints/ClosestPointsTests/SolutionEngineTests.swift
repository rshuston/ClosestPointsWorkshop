//
//  SolutionEngineTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/3/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import ClosestPoints

class SolutionEngineTests: XCTestCase {

    func test_findClosestPoints_NaiveCombination_ReturnsNilForEmptyPointSet() {
        let points: [Point] = []
        let subject = SolutionEngine()

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints_NaiveCombination(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNil(closestPoints)
            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_ReturnsNilForInsufficientPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints_NaiveCombination(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNil(closestPoints)
            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForTrivialPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints_NaiveCombination(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[0])
                XCTAssertEqual(closestPoints!.1, points[1])
            } else {
                XCTAssertEqual(closestPoints!.0, points[1])
                XCTAssertEqual(closestPoints!.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_CallsMonitorClosureForTrivialPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints_NaiveCombination(points: points, monitor: {
            (closestPoints: (Point, Point)?) -> Void in
            monitorCount += 1

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[0])
                XCTAssertEqual(closestPoints!.1, points[1])
            } else {
                XCTAssertEqual(closestPoints!.0, points[1])
                XCTAssertEqual(closestPoints!.1, points[0])
            }
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 1)

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[0])
                XCTAssertEqual(closestPoints!.1, points[1])
            } else {
                XCTAssertEqual(closestPoints!.0, points[1])
                XCTAssertEqual(closestPoints!.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForTrinaryPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints_NaiveCombination(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[0])
                XCTAssertEqual(closestPoints!.1, points[2])
            } else {
                XCTAssertEqual(closestPoints!.0, points[2])
                XCTAssertEqual(closestPoints!.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_CallsMonitorClosureForTrinaryPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")
        var monitorCount = 0

        subject.findClosestPoints_NaiveCombination(points: points, monitor: {
            (closestPoints: (Point, Point)?) -> Void in
            monitorCount += 1

            XCTAssertNotNil(closestPoints)
        }, completion: {
            (closestPoints: (Point, Point)?) -> Void in

            XCTAssertEqual(monitorCount, 6) // Permutation (nPr) of 3P2 = 6

            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[0])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[0])
                XCTAssertEqual(closestPoints!.1, points[2])
            } else {
                XCTAssertEqual(closestPoints!.0, points[2])
                XCTAssertEqual(closestPoints!.1, points[0])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForMultiplePointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 10, y: 10))
        points.append(Point(x: 101, y: 101))
        points.append(Point(x: 3, y: 4))

        let completionExpectation = expectation(description: "completion")

        subject.findClosestPoints_NaiveCombination(points: points, monitor: nil, completion: {
            (closestPoints: (Point, Point)?) -> Void in
            XCTAssertNotNil(closestPoints)

            let listOrdered = (closestPoints!.0 == points[1])
            if listOrdered {
                XCTAssertEqual(closestPoints!.0, points[1])
                XCTAssertEqual(closestPoints!.1, points[3])
            } else {
                XCTAssertEqual(closestPoints!.0, points[3])
                XCTAssertEqual(closestPoints!.1, points[1])
            }

            completionExpectation.fulfill()
        })

        waitForExpectations(timeout: 1.0, handler: nil)
    }

}

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

        let result = subject.findClosestPoints_NaiveCombination(points: points)

        XCTAssertNil(result)
    }

    func test_findClosestPoints_NaiveCombination_ReturnsNilForInsufficientPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))

        let result = subject.findClosestPoints_NaiveCombination(points: points)

        XCTAssertNil(result)
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForTrivialPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 3, y: 4))

        let result = subject.findClosestPoints_NaiveCombination(points: points)

        XCTAssertNotNil(result)

        let listOrdered = (result!.0 == points[0])
        if listOrdered {
            XCTAssertEqual(result!.0, points[0])
            XCTAssertEqual(result!.1, points[1])
        } else {
            XCTAssertEqual(result!.0, points[1])
            XCTAssertEqual(result!.1, points[0])
        }
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForTrinaryPointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 3, y: 4))

        let result = subject.findClosestPoints_NaiveCombination(points: points)

        XCTAssertNotNil(result)

        let listOrdered = (result!.0 == points[0])
        if listOrdered {
            XCTAssertEqual(result!.0, points[0])
            XCTAssertEqual(result!.1, points[2])
        } else {
            XCTAssertEqual(result!.0, points[2])
            XCTAssertEqual(result!.1, points[0])
        }
    }

    func test_findClosestPoints_NaiveCombination_FindsClosestPointsForMultiplePointSet() {
        var points: [Point] = []
        let subject = SolutionEngine()

        points.append(Point(x: 1, y: 2))
        points.append(Point(x: 100, y: 100))
        points.append(Point(x: 101, y: 101))
        points.append(Point(x: 3, y: 4))

        let result = subject.findClosestPoints_NaiveCombination(points: points)

        XCTAssertNotNil(result)

        let listOrdered = (result!.0 == points[1])
        if listOrdered {
            XCTAssertEqual(result!.0, points[1])
            XCTAssertEqual(result!.1, points[2])
        } else {
            XCTAssertEqual(result!.0, points[2])
            XCTAssertEqual(result!.1, points[1])
        }
    }

}

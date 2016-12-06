//
//  PointCollectionTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest
@testable import ClosestPoints

class PointCollectionTests: XCTestCase {

    func test_PointCollection_DefaultInitializesWithEmptyList() {
        let subject = PointCollection()

        XCTAssertEqual(subject.points.count, 0)
    }

    func test_PointCollection_InitializesWithGivenList() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]

        let subject = PointCollection(withPoints: points)

        XCTAssertEqual(subject.points.count, 2)

        XCTAssertEqual(subject.points[0].x, 1)
        XCTAssertEqual(subject.points[0].y, 2)

        XCTAssertEqual(subject.points[1].x, 3)
        XCTAssertEqual(subject.points[1].y, 4)
    }

    func test_PointCollection_clear_RemovesPointsFromList() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]

        let subject = PointCollection()
        subject.points = points

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
    }

    func test_PointCollection_clear_RemovesClosestPointsPair() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.closestPoints = pair

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
        XCTAssertNil(subject.closestPoints)
    }

    func test_PointCollection_generateUniformRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.generateUniformRandomPoints(numberOfPoints: 10, maxX: 100, maxY: 100, margin: 8)

        XCTAssertEqual(subject.points.count, 10)
    }

    func test_PointCollection_generateClusteredRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.generateClusteredRandomPoints(numberOfPoints: 10, maxX: 100, maxY: 100, margin: 8)

        XCTAssertEqual(subject.points.count, 10)
    }

}

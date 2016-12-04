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

        XCTAssertEqual(subject.points[0].p.x, 1)
        XCTAssertEqual(subject.points[0].p.y, 2)

        XCTAssertEqual(subject.points[1].p.x, 3)
        XCTAssertEqual(subject.points[1].p.y, 4)
    }

    func test_PointCollection_clear_RemovesPointsFromList() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]

        let subject = PointCollection()
        subject.points = points

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
    }

    func test_PointCollection_generateUniformRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.generateUniformRandomPoints(numberOfPoints: 10)

        XCTAssertEqual(subject.points.count, 10)
    }

    func test_PointCollection_generateClusteredRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.generateClusteredRandomPoints(numberOfPoints: 10)

        XCTAssertEqual(subject.points.count, 10)
    }

}

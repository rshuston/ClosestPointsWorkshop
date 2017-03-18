//
//  PointCollectionTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

import GameKit

@testable import ClosestPoints

class PointCollectionTests: XCTestCase {

    var mockGKRandomDistribution: MockGKRandomDistribution!

    override func setUp() {
        super.setUp()
        
        mockGKRandomDistribution = MockGKRandomDistribution(lowestValue: 0, highestValue: 10)
    }

    override func tearDown() {
        mockGKRandomDistribution = nil
        
        super.tearDown()
    }

    func test_init_DefaultInitializesWithEmptyList() {
        let subject = PointCollection()

        XCTAssertEqual(subject.points.count, 0)
    }

    func test_init_InitializesWithGivenList() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]

        let subject = PointCollection(withPoints: points)

        XCTAssertEqual(subject.points.count, 2)

        XCTAssertEqual(subject.points[0].x, 1)
        XCTAssertEqual(subject.points[0].y, 2)

        XCTAssertEqual(subject.points[1].x, 3)
        XCTAssertEqual(subject.points[1].y, 4)
    }

    func test_clear_RemovesPointsFromList() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]

        let subject = PointCollection()
        subject.points = points

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
    }

    func test_clear_RemovesClosestPointsPairAndColor() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.closestPoints = pair
        subject.closestPointsColor = NSColor.green

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
        XCTAssertNil(subject.closestPoints)
        XCTAssertNil(subject.closestPointsColor)
    }

    func test_clear_RemovesCheckPointsPairAndColor() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.checkPoints = pair
        subject.checkPointsColor = NSColor.yellow

        subject.clear()

        XCTAssertEqual(subject.points.count, 0)
        XCTAssertNil(subject.checkPoints)
        XCTAssertNil(subject.checkPointsColor)
    }

    func test_clearAllDataExceptForPoints_RemovesOnlyClosestPointsPairAndColor() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.closestPoints = pair
        subject.closestPointsColor = NSColor.green
        subject.checkPoints = pair
        subject.checkPointsColor = NSColor.yellow
        subject.searchRect = NSRect(x: 0, y: 0, width: 100, height: 100)

        subject.clearAllDataExceptForPoints()

        XCTAssertEqual(subject.points.count, 2)
        XCTAssertNil(subject.closestPoints)
        XCTAssertNil(subject.closestPointsColor)
        XCTAssertNil(subject.checkPoints)
        XCTAssertNil(subject.checkPointsColor)
        XCTAssertNil(subject.searchRect)
    }

    func test_generateUniformRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.distributionRange = 10

        mockGKRandomDistribution.count = 0
        mockGKRandomDistribution.incr = 1

        subject.uniformDistributionFactory = { (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
                return self.mockGKRandomDistribution
            }
        
        subject.generateUniformRandomPoints(numberOfPoints: 5, maxX: 12, maxY: 12, margin: 1)

        XCTAssertEqual(subject.points.count, 5)

        // Note: The range 0..12 with a margin of 1 maps to an inner range of 0..10.
        // Hence, each mocked random value should start at 1 and get mapped to 1 with
        // an added margin of 1.
        XCTAssertEqual(subject.points[0].x, 2)
        XCTAssertEqual(subject.points[0].y, 3)
        XCTAssertEqual(subject.points[1].x, 4)
        XCTAssertEqual(subject.points[1].y, 5)
        XCTAssertEqual(subject.points[2].x, 6)
        XCTAssertEqual(subject.points[2].y, 7)
        XCTAssertEqual(subject.points[3].x, 8)
        XCTAssertEqual(subject.points[3].y, 9)
        XCTAssertEqual(subject.points[4].x, 10)
        XCTAssertEqual(subject.points[4].y, 11)
    }

    // Note: The range 0..12 with a margin of 1 maps to an inner range of 0..10.
    // Hence, each mocked random value should start at 1 and get mapped to 1 with
    // an added margin of 1.
    func test_generateClusteredRandomPoints_PopulatesList() {
        let subject = PointCollection()

        subject.distributionRange = 10

        mockGKRandomDistribution.count = 0
        mockGKRandomDistribution.incr = 1

        subject.gaussianDistributionFactory = { (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
            return self.mockGKRandomDistribution
        }

        subject.generateClusteredRandomPoints(numberOfPoints: 5, maxX: 12, maxY: 12, margin: 1)

        XCTAssertEqual(subject.points.count, 5)

        XCTAssertEqual(subject.points[0].x, 2)
        XCTAssertEqual(subject.points[0].y, 3)
        XCTAssertEqual(subject.points[1].x, 4)
        XCTAssertEqual(subject.points[1].y, 5)
        XCTAssertEqual(subject.points[2].x, 6)
        XCTAssertEqual(subject.points[2].y, 7)
        XCTAssertEqual(subject.points[3].x, 8)
        XCTAssertEqual(subject.points[3].y, 9)
        XCTAssertEqual(subject.points[4].x, 10)
        XCTAssertEqual(subject.points[4].y, 11)
    }

    class MockGKRandomDistribution: GKRandomDistribution {

        var count = -1
        var incr = 1

        override func nextInt() -> Int {
            count += incr
            return count
        }

    }

}

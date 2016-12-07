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
        mockGKRandomDistribution = MockGKRandomDistribution(lowestValue: 0, highestValue: 10)

        super.setUp()
    }

    override func tearDown() {
        mockGKRandomDistribution = nil
        
        super.tearDown()
    }

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

    func test_PointCollection_clear_RemovesClosestPointsPairAndColor() {
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

    func test_PointCollection_clear_RemovesCheckPointsPairAndColor() {
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

    func test_PointCollection_clearClosestPoints_RemovesOnlyClosestPointsPairAndColor() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.closestPoints = pair
        subject.closestPointsColor = NSColor.green
        subject.checkPoints = pair
        subject.checkPointsColor = NSColor.yellow

        subject.clearClosestPoints()

        XCTAssertEqual(subject.points.count, 2)
        XCTAssertNil(subject.closestPoints)
        XCTAssertNil(subject.closestPointsColor)
        XCTAssertNotNil(subject.checkPoints)
        XCTAssertNotNil(subject.checkPointsColor)
    }

    func test_PointCollection_clearCheckPoints_RemovesOnlyCheckPointsPairAndColor() {
        let points = [ Point(x: 1, y: 2), Point(x: 3, y: 4) ]
        let pair = (points[0], points[1])

        let subject = PointCollection()
        subject.points = points
        subject.closestPoints = pair
        subject.closestPointsColor = NSColor.green
        subject.checkPoints = pair
        subject.checkPointsColor = NSColor.yellow

        subject.clearCheckPoints()

        XCTAssertEqual(subject.points.count, 2)
        XCTAssertNotNil(subject.closestPoints)
        XCTAssertNotNil(subject.closestPointsColor)
        XCTAssertNil(subject.checkPoints)
        XCTAssertNil(subject.checkPointsColor)
    }

    func test_PointCollection_generateUniformRandomPoints_PopulatesList() {
        let subject = PointCollection()

        mockGKRandomDistribution.count = 0

        subject.uniformDistributionFactory = { (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
                return self.mockGKRandomDistribution
            }
        
        subject.generateUniformRandomPoints(numberOfPoints: 5, maxX: 100, maxY: 100, margin: 8)

        XCTAssertEqual(subject.points.count, 5)

        XCTAssertEqual(subject.points[0].x, 1)
        XCTAssertEqual(subject.points[0].y, 2)
        XCTAssertEqual(subject.points[1].x, 3)
        XCTAssertEqual(subject.points[1].y, 4)
        XCTAssertEqual(subject.points[2].x, 5)
        XCTAssertEqual(subject.points[2].y, 6)
        XCTAssertEqual(subject.points[3].x, 7)
        XCTAssertEqual(subject.points[3].y, 8)
        XCTAssertEqual(subject.points[4].x, 9)
        XCTAssertEqual(subject.points[4].y, 10)
    }

    func test_PointCollection_generateClusteredRandomPoints_PopulatesList() {
        let subject = PointCollection()

        mockGKRandomDistribution.count = 0

        subject.gaussianDistributionFactory = { (lowestValue: Int, highestValue: Int) -> GKRandomDistribution in
            return self.mockGKRandomDistribution
        }

        subject.generateClusteredRandomPoints(numberOfPoints: 5, maxX: 100, maxY: 100, margin: 8)

        XCTAssertEqual(subject.points.count, 5)

        XCTAssertEqual(subject.points[0].x, 1)
        XCTAssertEqual(subject.points[0].y, 2)
        XCTAssertEqual(subject.points[1].x, 3)
        XCTAssertEqual(subject.points[1].y, 4)
        XCTAssertEqual(subject.points[2].x, 5)
        XCTAssertEqual(subject.points[2].y, 6)
        XCTAssertEqual(subject.points[3].x, 7)
        XCTAssertEqual(subject.points[3].y, 8)
        XCTAssertEqual(subject.points[4].x, 9)
        XCTAssertEqual(subject.points[4].y, 10)
    }

    class MockGKRandomDistribution: GKRandomDistribution {

        var count = -1

        override func nextInt() -> Int {
            count += 1
            return count
        }

    }

}

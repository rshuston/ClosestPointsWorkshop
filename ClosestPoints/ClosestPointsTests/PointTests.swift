//
//  PointTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/2/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import ClosestPoints

class PointTests: XCTestCase {

    func test_Point_InitializesWithCoordinates() {
        let x: CGFloat = 1
        let y: CGFloat = 2

        let subject = Point(x: x, y: y)

        XCTAssertEqual(subject.x, x)
        XCTAssertEqual(subject.y, y)
    }

    func test_Point_InitializesWithNSPoint() {
        let point = NSPoint(x: 1, y: 2)

        let subject = Point(withNSPoint: point)

        XCTAssertEqual(subject.x, point.x)
        XCTAssertEqual(subject.y, point.y)
    }

    func test_Point_getAsNSPoint_returnsValueAsNSPoint() {
        let point = NSPoint(x: 1, y: 2)

        let subject = Point(withNSPoint: point)

        let result = subject.getAsNSPoint()

        XCTAssertEqual(result, point)
    }

}

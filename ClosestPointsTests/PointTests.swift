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

    func test_Point_InitializesWithCorrectPosition() {
        let x: CGFloat = 1
        let y: CGFloat = 2

        let subject = Point(x: x, y: y)

        XCTAssertEqual(subject.p.x, x)
        XCTAssertEqual(subject.p.y, y)
    }

}

//
//  AppUtilsTests.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/9/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest

@testable import ClosestPoints

class AppUtilsTests: XCTestCase {

    func test_IsNSPointOnNSPointWithMargin_DoesNotDetectPointOnPointForNegativeMargin() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 1, y: 2)

        let result = AppUtils.IsNSPoint(point: testPoint, onNSPoint: referencePoint, withMargin: -1)

        XCTAssertFalse(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForExactMatch() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 1, y: 2)

        let result = AppUtils.IsNSPoint(point: testPoint, onNSPoint: referencePoint, withMargin: 0)

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForLinearMargin() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 1, y: 3)

        let result = AppUtils.IsNSPoint(point: testPoint, onNSPoint: referencePoint, withMargin: 1)

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForDiagonalMargin() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 2, y: 3)

        let result = AppUtils.IsNSPoint(point: testPoint, onNSPoint: referencePoint, withMargin: sqrt(2))

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DoesNotDetectPointOnPointForInsufficientMargin() {
        let testPoint = NSPoint(x: -1, y: -2)
        let referencePoint = NSPoint(x: 2, y: 3)

        let result = AppUtils.IsNSPoint(point: testPoint, onNSPoint: referencePoint, withMargin: 1)

        XCTAssertFalse(result)
    }

    func test_PinNSPointToNSRectWithMargin_DoesNotAffectPointIfAlreadyInsideRectangleWithMargin() {
        let testPoint = NSPoint(x: 2, y: 2)
        let referenceRect = NSRect(x: 0, y: 0, width: 3, height: 3)

        let pinnedPoint = AppUtils.PinNSPoint(point: testPoint, toNSRect: referenceRect, withMargin: 1)

        XCTAssertEqual(pinnedPoint, testPoint)
    }

    func test_PinNSPointToNSRectWithMargin_PinsPointToWhenPointIsNotInsideMargin() {
        let testPoint = NSPoint(x: -2, y: 2)
        let referenceRect = NSRect(x: -1, y: -1, width: 4, height: 4)
        let expectedPoint = NSPoint(x: -0.5, y: 2)

        let pinnedPoint = AppUtils.PinNSPoint(point: testPoint, toNSRect: referenceRect, withMargin: 0.5)

        XCTAssertEqual(pinnedPoint, expectedPoint)
    }

    func test_PinNSPointToNSRectWithMargin_PinsPointToWhenPointIsNotInsideRectangle() {
        let testPoint = NSPoint(x: -5, y: 5)
        let referenceRect = NSRect(x: -1, y: -1, width: 4, height: 4)
        let expectedPoint = NSPoint(x: -0.5, y: 2.5)

        let pinnedPoint = AppUtils.PinNSPoint(point: testPoint, toNSRect: referenceRect, withMargin: 0.5)

        XCTAssertEqual(pinnedPoint, expectedPoint)
    }

}

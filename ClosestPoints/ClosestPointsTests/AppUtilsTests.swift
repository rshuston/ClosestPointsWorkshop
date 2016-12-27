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

        let result = AppUtils.IsNSPoint(testPoint, onNSPoint: referencePoint, withMargin: -1)

        XCTAssertFalse(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForExactMatch() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 1, y: 2)

        let result = AppUtils.IsNSPoint(testPoint, onNSPoint: referencePoint, withMargin: 0)

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForLinearMargin() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 1, y: 3)

        let result = AppUtils.IsNSPoint(testPoint, onNSPoint: referencePoint, withMargin: 1)

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DetectsPointOnPointForDiagonalMargin() {
        let testPoint = NSPoint(x: 1, y: 2)
        let referencePoint = NSPoint(x: 2, y: 3)

        let result = AppUtils.IsNSPoint(testPoint, onNSPoint: referencePoint, withMargin: sqrt(2))

        XCTAssertTrue(result)
    }

    func test_IsNSPointOnNSPointWithMargin_DoesNotDetectPointOnPointForInsufficientMargin() {
        let testPoint = NSPoint(x: -1, y: -2)
        let referencePoint = NSPoint(x: 2, y: 3)

        let result = AppUtils.IsNSPoint(testPoint, onNSPoint: referencePoint, withMargin: 1)

        XCTAssertFalse(result)
    }

    func test_PinNSPointToNSRectWithMargin_DoesNotAffectPointIfAlreadyInsideRectangleWithMargin() {
        let testPoint = NSPoint(x: 2, y: 2)
        let referenceRect = NSRect(x: 0, y: 0, width: 3, height: 3)

        let pinnedPoint = AppUtils.PinNSPoint(testPoint, toNSRect: referenceRect, withMargin: 1)

        XCTAssertEqual(pinnedPoint, testPoint)
    }

    func test_PinNSPointToNSRectWithMargin_PinsPointToWhenPointIsNotInsideMargin() {
        let testPoint = NSPoint(x: -2, y: 2)
        let referenceRect = NSRect(x: -1, y: -1, width: 4, height: 4)
        let expectedPoint = NSPoint(x: -0.5, y: 2)

        let pinnedPoint = AppUtils.PinNSPoint(testPoint, toNSRect: referenceRect, withMargin: 0.5)

        XCTAssertEqual(pinnedPoint, expectedPoint)
    }

    func test_PinNSPointToNSRectWithMargin_PinsPointToWhenPointIsNotInsideRectangle() {
        let testPoint = NSPoint(x: -5, y: 5)
        let referenceRect = NSRect(x: -1, y: -1, width: 4, height: 4)
        let expectedPoint = NSPoint(x: -0.5, y: 2.5)

        let pinnedPoint = AppUtils.PinNSPoint(testPoint, toNSRect: referenceRect, withMargin: 0.5)

        XCTAssertEqual(pinnedPoint, expectedPoint)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoHorizontalPoints() {
        let pt1 = NSPoint(x: 0, y: 0)
        let pt2 = NSPoint(x: 2, y: 0)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, 0)
        XCTAssertEqual(rect.origin.y, 0)
        XCTAssertEqual(rect.size.width, 2)
        XCTAssertEqual(rect.size.height, 0)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoMoreHorizontalPoints() {
        let pt1 = NSPoint(x: 3, y: 0)
        let pt2 = NSPoint(x: 0, y: 0)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, 0)
        XCTAssertEqual(rect.origin.y, 0)
        XCTAssertEqual(rect.size.width, 3)
        XCTAssertEqual(rect.size.height, 0)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoVerticalPoints() {
        let pt1 = NSPoint(x: -1, y: -1)
        let pt2 = NSPoint(x: -1, y: 1)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, -1)
        XCTAssertEqual(rect.origin.y, -1)
        XCTAssertEqual(rect.size.width, 0)
        XCTAssertEqual(rect.size.height, 2)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoMoreVerticalPoints() {
        let pt1 = NSPoint(x: -1, y: 1)
        let pt2 = NSPoint(x: -1, y: -2)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, -1)
        XCTAssertEqual(rect.origin.y, -2)
        XCTAssertEqual(rect.size.width, 0)
        XCTAssertEqual(rect.size.height, 3)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoDiagonalPoints() {
        let pt1 = NSPoint(x: 1, y: 1)
        let pt2 = NSPoint(x: 10, y: 10)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, 1)
        XCTAssertEqual(rect.origin.y, 1)
        XCTAssertEqual(rect.size.width, 9)
        XCTAssertEqual(rect.size.height, 9)
    }

    func test_NSRectFromNSPoints_CreatesRectangleFromTwoMoreDiagonalPoints() {
        let pt1 = NSPoint(x: 5, y: 0)
        let pt2 = NSPoint(x: -1, y: 6)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, -1)
        XCTAssertEqual(rect.origin.y, 0)
        XCTAssertEqual(rect.size.width, 6)
        XCTAssertEqual(rect.size.height, 6)
    }

    func test_NSRectFromNSPoints_CreatesEmptyRectangleFromTwoIdenticalPoints() {
        let pt1 = NSPoint(x: 5, y: 5)
        let pt2 = NSPoint(x: 5, y: 5)

        let rect = AppUtils.NSRectFromNSPoints(pt1, pt2)

        XCTAssertEqual(rect.origin.x, 5)
        XCTAssertEqual(rect.origin.y, 5)
        XCTAssertEqual(rect.size.width, 0)
        XCTAssertEqual(rect.size.height, 0)
    }

}

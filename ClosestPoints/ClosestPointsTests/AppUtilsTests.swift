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

    func test_ScaleIntToCGFloat_ReturnsZeroForEmptyDomain() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (5, 5), range: (0.0, 10.0), margin: 0.0)

        XCTAssertEqual(y, 0.0);
    }

    func test_ScaleIntToCGFloat_ReturnsZeroForIncorrectDomain() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (5, 0), range: (0.0, 10.0), margin: 0.0)

        XCTAssertEqual(y, 0.0);
    }

    func test_ScaleIntToCGFloat_ReturnsZeroForEmptyRange() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (0, 5), range: (10.0, 10.0), margin: 0.0)

        XCTAssertEqual(y, 0.0);
    }

    func test_ScaleIntToCGFloat_ReturnsZeroForIncorrectRange() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (0, 5), range: (10.0, 0.0), margin: 0.0)

        XCTAssertEqual(y, 0.0);
    }

    func test_ScaleIntToCGFloat_ReturnsMidRangeForMidDomainAndZeroMargin() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (0, 10), range: (0.0, 100.0), margin: 0.0)

        XCTAssertEqual(y, 50.0);
    }

    func test_ScaleIntToCGFloat_ReturnsMidRangeForMidDomainButNonZeroMargin() {
        let y = AppUtils.ScaleIntToCGFloat(5, domain: (0, 10), range: (0.0, 100.0), margin: 10.0)

        XCTAssertEqual(y, 50.0);
    }

    func test_ScaleIntToCGFloat_GeneralTest1() {
        let y = AppUtils.ScaleIntToCGFloat(2, domain: (0, 10), range: (0.0, 100.0), margin: 10.0)

        XCTAssertEqual(y, 26.0);
    }

    func test_ScaleIntToCGFloat_GeneralTest2() {
        let y = AppUtils.ScaleIntToCGFloat(3, domain: (0, 4), range: (0.0, 42.0), margin: 1.0)

        XCTAssertEqual(y, 31.0);
    }

    func test_ScaleIntToCGFloat_GeneralTest3() {
        let y = AppUtils.ScaleIntToCGFloat(Int.max / 4, domain: (0, Int.max), range: (0.0, 102.0), margin: 1.0)

        XCTAssertEqual(y, 26.0);
    }

}

//
//  SegmentedSequenceListTests.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/5/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest
@testable import PDLToolBox

class SegmentedSequenceListTests: XCTestCase {

    var subject: SegmentedSequenceList!

    override func setUp() {
        super.setUp()

        subject = SegmentedSequenceList()
    }
    
    override func tearDown() {
        subject = nil
        
        super.tearDown()
    }

    func test_init_fromList() {
        let localSubject = SegmentedSequenceList(fromList: [(1, "foo"), (2, "bar")])

        XCTAssertEqual(2, localSubject.sequenceList.count)
        let entry1 = localSubject.sequenceList[0]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("foo", entry1.value as? String)
        let entry2 = localSubject.sequenceList[1]
        XCTAssertEqual(2, entry2.index)
        XCTAssertEqual("bar", entry2.value as? String)
    }

    func test_clear() {
        subject.sequenceList = [
            (0, "value1"),
            (3, "value2"),
            (6, "value3")
        ]

        subject.clear()

        XCTAssertEqual(0, subject.sequenceList.count)
    }

    func test_setValue_addsFirstEntry() {
        subject.sequenceList = []

        subject.setValue("value", forIndex: 0)

        XCTAssertEqual(1, subject.sequenceList.count)
        let entry = subject.sequenceList[0]
        XCTAssertEqual(0, entry.index)
        XCTAssertEqual("value", entry.value as? String)
    }

    func test_setValue_addsConsecutiveEntries_postfix() {
        subject.sequenceList = [(0, "value1")]

        subject.setValue("value2", forIndex: 1)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry1 = subject.sequenceList[0]
        XCTAssertEqual(0, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
        let entry2 = subject.sequenceList[1]
        XCTAssertEqual(1, entry2.index)
        XCTAssertEqual("value2", entry2.value as? String)
    }

    func test_setValue_addsConsecutiveEntries_prefix() {
        subject.sequenceList = [(1, "value1")]

        subject.setValue("value0", forIndex: 0)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry1 = subject.sequenceList[0]
        XCTAssertEqual(0, entry1.index)
        XCTAssertEqual("value0", entry1.value as? String)
        let entry2 = subject.sequenceList[1]
        XCTAssertEqual(1, entry2.index)
        XCTAssertEqual("value1", entry2.value as? String)
    }

    func test_setValue_replacesExistingEntries() {
        subject.sequenceList = [(0, "value0"), (1, "value2")]

        subject.setValue("value1", forIndex: 1)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry0 = subject.sequenceList[0]
        XCTAssertEqual(0, entry0.index)
        XCTAssertEqual("value0", entry0.value as? String)
        let entry1 = subject.sequenceList[1]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
    }

    func test_setValue_addsSegmentedEntries() {
        subject.sequenceList = [(0, "value0"), (2, "value2")]

        subject.setValue("value1", forIndex: 1)

        XCTAssertEqual(3, subject.sequenceList.count)
        let entry0 = subject.sequenceList[0]
        XCTAssertEqual(0, entry0.index)
        XCTAssertEqual("value0", entry0.value as? String)
        let entry1 = subject.sequenceList[1]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
        let entry2 = subject.sequenceList[2]
        XCTAssertEqual(2, entry2.index)
        XCTAssertEqual("value2", entry2.value as? String)
    }

    func test_setValue_addsDissimilarEntries() {
        subject.sequenceList = [(1, "value1")]

        subject.setValue(3.0, forIndex: 3)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry1 = subject.sequenceList[0]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
        let entry2 = subject.sequenceList[1]
        XCTAssertEqual(3, entry2.index)
        XCTAssertEqual(3.0, entry2.value as? Double)
    }

    func test_setValue_addsClosureEntries() {
        var testValue = 0
        let three = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.sequenceList = [(1, "value1")]

        subject.setValue(three, forIndex: 3)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry1 = subject.sequenceList[0]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
        let entry2 = subject.sequenceList[1]
        let closure = entry2.value as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_setValue_addsNilEntries() {
        subject.sequenceList = [(1, "value1")]

        subject.setValue(nil, forIndex: 3)

        XCTAssertEqual(2, subject.sequenceList.count)
        let entry1 = subject.sequenceList[0]
        XCTAssertEqual(1, entry1.index)
        XCTAssertEqual("value1", entry1.value as? String)
        let entry2 = subject.sequenceList[1]
        XCTAssertEqual(3, entry2.index)
        XCTAssertNil(entry2.value)
    }

    func test_getValueFor_failsForEmptyList() {
        subject.sequenceList = []

        let result = subject.getValueFor(1)

        XCTAssertFalse(result.success)
        XCTAssertNil(result.value)
    }

    func test_getValueFor_implicitMatchForSingleEntry() {
        subject.sequenceList = [
            (1, "value1")
        ]

        let result = subject.getValueFor(2)

        XCTAssertTrue(result.success)
        XCTAssertEqual("value1", result.value as? String)
    }

    func test_getValueFor_matchAtSegmentBoundary() {
        subject.sequenceList = [
            (1, "value1"),
            (3, "value3"),
            (6, "value6")
        ]

        let result = subject.getValueFor(3)

        XCTAssertTrue(result.success)
        XCTAssertEqual("value3", result.value as? String)
    }

    func test_getValueFor_matchWithinSegment() {
        subject.sequenceList = [
            (1, "value1"),
            (3, "value3"),
            (6, "value6")
        ]

        let result = subject.getValueFor(4)

        XCTAssertTrue(result.success)
        XCTAssertEqual("value3", result.value as? String)
    }

    func test_getValueFor_rangeBeforeList() {
        subject.sequenceList = [
            (1, "value1"),
            (3, "value3"),
            (6, "value6")
        ]

        let result = subject.getValueFor(0)

        XCTAssertTrue(result.success)
        XCTAssertEqual("value1", result.value as? String)
    }

    func test_getValueFor_rangeBeyondList() {
        subject.sequenceList = [
            (1, "value1"),
            (3, "value3"),
            (6, "value6")
        ]

        let result = subject.getValueFor(7)

        XCTAssertTrue(result.success)
        XCTAssertEqual("value6", result.value as? String)
    }

    func test_getValueFor_retrievesClosureEntries() {
        var testValue = 0
        let three = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.sequenceList = [
            (1, "value1"),
            (3, three),
            (6, "value6")
        ]

        let result = subject.getValueFor(4)

        XCTAssertTrue(result.success)
        let closure = result.value as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_getValueFor_retrievesNilEntries() {
        subject.sequenceList = [
            (1, "value1"),
            (3, nil),
            (6, "value6")
        ]

        let result = subject.getValueFor(4)

        XCTAssertTrue(result.success)
        XCTAssertNil(result.value)
    }

}

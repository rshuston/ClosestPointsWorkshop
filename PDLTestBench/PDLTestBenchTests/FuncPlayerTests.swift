//
//  FuncFuncPlayerTests.swift
//  PDLTestBench
//
//  Created by Robert Huston on 6/4/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest
@testable import PDLTestBench
@testable import PDLToolBox // Needs to be testable to access SegmentedSequenceList elements

class FuncFuncPlayerTests: XCTestCase {

    var subject: FuncPlayer!

    override func setUp() {
        super.setUp()

        subject = FuncPlayer()
    }
    
    override func tearDown() {
        subject = nil
        
        super.tearDown()
    }

    func test_setReturnValue_PopulatesEmptyDictionaryWithNewValueAtDefaultInvocation() {
        subject.returnValuesDictionary = [:]

        subject.setReturnValue("value", forName: "foo")

        XCTAssertEqual(1, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["foo"]?.segmentedSequenceList
        XCTAssertEqual(1, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        XCTAssertEqual("value", entry1?.value as? String)
    }

    func test_setReturnValue_AddsNewValueAtDefaultInvocationForNewNameToExistingDictionary() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 1)
        ]

        subject.setReturnValue("heehaw", forName: "plugh")

        XCTAssertEqual(2, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["plugh"]?.segmentedSequenceList
        XCTAssertEqual(1, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        XCTAssertEqual("heehaw", entry1?.value as? String)
    }

    func test_setReturnValue_ChangesValueAtExistingDefaultInvocationForExistingNameOfExistingDictionary() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        subject.setReturnValue("heehaw", forName: "xyzzy")

        XCTAssertEqual(1, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["xyzzy"]?.segmentedSequenceList
        XCTAssertEqual(4, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        XCTAssertEqual("heehaw", entry1?.value as? String)
        let entry2 = segmentedSequenceList?.sequenceList[1]
        XCTAssertEqual(3, entry2?.index)
        XCTAssertEqual("bar", entry2?.value as? String)
        let entry3 = segmentedSequenceList?.sequenceList[2]
        XCTAssertEqual(5, entry3?.index)
        XCTAssertEqual("boo", entry3?.value as? String)
        let entry4 = segmentedSequenceList?.sequenceList[3]
        XCTAssertEqual(7, entry4?.index)
        XCTAssertEqual("far", entry4?.value as? String)
    }

    func test_setReturnValue_AddsNewValueForNonExistingInvocationForExistingNameOfExistingDictionary() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        subject.setReturnValue("heehaw", forName: "xyzzy", forInvocation: 6)

        XCTAssertEqual(1, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["xyzzy"]?.segmentedSequenceList
        XCTAssertEqual(5, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        XCTAssertEqual("foo", entry1?.value as? String)
        let entry2 = segmentedSequenceList?.sequenceList[1]
        XCTAssertEqual(3, entry2?.index)
        XCTAssertEqual("bar", entry2?.value as? String)
        let entry3 = segmentedSequenceList?.sequenceList[2]
        XCTAssertEqual(5, entry3?.index)
        XCTAssertEqual("boo", entry3?.value as? String)
        let entry4 = segmentedSequenceList?.sequenceList[3]
        XCTAssertEqual(6, entry4?.index)
        XCTAssertEqual("heehaw", entry4?.value as? String)
        let entry5 = segmentedSequenceList?.sequenceList[4]
        XCTAssertEqual(7, entry5?.index)
        XCTAssertEqual("far", entry5?.value as? String)
    }

    func test_setReturnValueFor_AcceptsClosures() {
        var testValue = 0
        let fooClosure = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.returnValuesDictionary = [:]

        subject.setReturnValue(fooClosure, forName: "foo")

        XCTAssertEqual(1, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["foo"]?.segmentedSequenceList
        XCTAssertEqual(1, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        let closure = entry1?.value as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_setReturnValueFor_AcceptsNilValues() {
        subject.returnValuesDictionary = [:]

        subject.setReturnValue(nil, forName: "foo")

        XCTAssertEqual(1, subject.returnValuesDictionary.count)
        let segmentedSequenceList = subject.returnValuesDictionary["foo"]?.segmentedSequenceList
        XCTAssertEqual(1, segmentedSequenceList?.sequenceList.count)
        let entry1 = segmentedSequenceList?.sequenceList[0]
        XCTAssertEqual(1, entry1?.index)
        XCTAssertNil(entry1?.value)
    }

    func test_getReturnValueFor_FailsForEmptyDictionary() {
        subject.returnValuesDictionary = [:]

        let result = subject.getReturnValueFor("xyzzy")

        XCTAssertFalse(result.success)
        XCTAssertNil(result.value)
    }

    func test_getReturnValueFor_ReturnsSameValueForDictionaryEntryWithSingleSequenceEntry() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (3, "fubar")
                    ]),
                pendingInvocation: 4)
        ]

        let result = subject.getReturnValueFor("xyzzy")

        XCTAssertTrue(result.success)
        XCTAssertEqual("fubar", result.value as? String)
        XCTAssertEqual(5, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsValuesForDictionaryEntryWithMultipleSequenceEntries() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        let result1 = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result1.success)
        XCTAssertEqual("bar", result1.value as? String)
        XCTAssertEqual(5, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        let result2 = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result2.success)
        XCTAssertEqual("boo", result2.value as? String)
        XCTAssertEqual(6, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsSameValueForDictionaryEntryWithSequenceEntryContainingClosure() {
        var testValue = 0
        let fubarClosure = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (3, fubarClosure)
                    ]),
                pendingInvocation: 4)
        ]

        let result = subject.getReturnValueFor("xyzzy")

        XCTAssertTrue(result.success)
        let closure = result.value as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
        XCTAssertEqual(5, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsValuesAtInvocationsForDictionaryEntryWithMultipleSequenceEntries() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        let result1 = subject.getReturnValueFor("xyzzy", forInvocation: 2)
        XCTAssertTrue(result1.success)
        XCTAssertEqual("foo", result1.value as? String)
        XCTAssertEqual(3, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        let result2 = subject.getReturnValueFor("xyzzy", forInvocation: 7)
        XCTAssertTrue(result2.success)
        XCTAssertEqual("far", result2.value as? String)
        XCTAssertEqual(8, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsSequencedValuesForDictionaryEntryWithMultipleSequenceEntries() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 1)
        ]

        var result: (value: Any?, success: Bool)
        
        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("foo", result.value as? String)
        XCTAssertEqual(2, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("foo", result.value as? String)
        XCTAssertEqual(3, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("bar", result.value as? String)
        XCTAssertEqual(4, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("bar", result.value as? String)
        XCTAssertEqual(5, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("boo", result.value as? String)
        XCTAssertEqual(6, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("boo", result.value as? String)
        XCTAssertEqual(7, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("far", result.value as? String)
        XCTAssertEqual(8, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)

        result = subject.getReturnValueFor("xyzzy")
        XCTAssertTrue(result.success)
        XCTAssertEqual("far", result.value as? String)
        XCTAssertEqual(9, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsSequencedValuesForMultipleDictionaryEntries() {
        subject.returnValuesDictionary = [
            "hee" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [(1, "foo"), (2, "bar")]),
                pendingInvocation: 1),
            "haw" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [(3, "boo"), (4, "far")]),
                pendingInvocation: 1)
        ]

        var hee_result: (value: Any?, success: Bool)
        var haw_result: (value: Any?, success: Bool)

        hee_result = subject.getReturnValueFor("hee")
        XCTAssertEqual("foo", hee_result.value as? String)
        haw_result = subject.getReturnValueFor("haw")
        XCTAssertEqual("boo", haw_result.value as? String)

        hee_result = subject.getReturnValueFor("hee")
        XCTAssertEqual("bar", hee_result.value as? String)
        haw_result = subject.getReturnValueFor("haw")
        XCTAssertEqual("boo", haw_result.value as? String)

        hee_result = subject.getReturnValueFor("hee")
        XCTAssertEqual("bar", hee_result.value as? String)
        haw_result = subject.getReturnValueFor("haw")
        XCTAssertEqual("boo", haw_result.value as? String)

        hee_result = subject.getReturnValueFor("hee")
        XCTAssertEqual("bar", hee_result.value as? String)
        haw_result = subject.getReturnValueFor("haw")
        XCTAssertEqual("far", haw_result.value as? String)

        hee_result = subject.getReturnValueFor("hee")
        XCTAssertEqual("bar", hee_result.value as? String)
        haw_result = subject.getReturnValueFor("haw")
        XCTAssertEqual("far", haw_result.value as? String)

        XCTAssertEqual(6, subject.returnValuesDictionary["hee"]?.pendingInvocation)
        XCTAssertEqual(6, subject.returnValuesDictionary["haw"]?.pendingInvocation)
    }

    func test_getReturnValueFor_ReturnsSequenceOfValuesAndNils() {
        subject.setReturnValue(3.14145256, forName: "getRadius")
        subject.setReturnValue(nil, forName: "getRadius", forInvocation: 2)

        XCTAssertEqual(1, subject.returnValuesDictionary["getRadius"]?.pendingInvocation)

        var result: (value: Any?, success: Bool)

        result = subject.getReturnValueFor("getRadius")
        XCTAssertTrue(result.success)
        XCTAssertEqual(3.14145256, result.value as? Double)
        XCTAssertEqual(2, subject.returnValuesDictionary["getRadius"]?.pendingInvocation)

        result = subject.getReturnValueFor("getRadius")
        XCTAssertTrue(result.success)
        XCTAssertNil(result.value)
        XCTAssertEqual(3, subject.returnValuesDictionary["getRadius"]?.pendingInvocation)

        result = subject.getReturnValueFor("getRadius")
        XCTAssertTrue(result.success)
        XCTAssertNil(result.value)
        XCTAssertEqual(4, subject.returnValuesDictionary["getRadius"]?.pendingInvocation)
    }

    func test_clearReturnValuesFor_ClearsForRegisteredNames() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        subject.clearReturnValuesFor("xyzzy")

        XCTAssertEqual(0, subject.returnValuesDictionary["xyzzy"]?.segmentedSequenceList.sequenceList.count)
        XCTAssertEqual(1, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_clearReturnValuesFor_DoesNotClearForUnregisteredNames() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

    }

    func test_clearAllReturnValues_ClearsAllEntries() {
        subject.returnValuesDictionary = [
            "hee" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [(1, "foo"), (2, "bar")]),
                pendingInvocation: 1),
            "haw" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [(3, "boo"), (4, "far")]),
                pendingInvocation: 1)
        ]

        subject.clearAllReturnValues()

        XCTAssertEqual(0, subject.returnValuesDictionary.count)
    }

    func test_resetSequencerFor_ResetsForRegisteredNames() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        subject.resetSequencerFor("xyzzy")

        XCTAssertEqual(1, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

    func test_resetSequencerFor_DoesNotResetForUnregisteredNames() {
        subject.returnValuesDictionary = [
            "xyzzy" : PDLTestBench.FuncPlayer.ValueSequencer(
                segmentedSequenceList: SegmentedSequenceList(fromList: [
                    (1, "foo"), (3, "bar"), (5, "boo"), (7, "far")
                    ]),
                pendingInvocation: 4)
        ]

        subject.resetSequencerFor("plugh")

        XCTAssertEqual(4, subject.returnValuesDictionary["xyzzy"]?.pendingInvocation)
    }

}

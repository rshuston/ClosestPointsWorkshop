//
//  StackTests.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/5/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest
@testable import PDLToolBox

class StackTests: XCTestCase {

    var subject: Stack!

    override func setUp() {
        super.setUp()

        subject = Stack()
    }
    
    override func tearDown() {
        subject = nil

        super.tearDown()
    }

    func test_init_FromList() {
        let localSubject = Stack(fromList: [1, 2, 3])

        XCTAssertEqual(3, localSubject.stack.count)
        XCTAssertEqual(1, localSubject.stack[0] as? Int)
        XCTAssertEqual(2, localSubject.stack[1] as? Int)
        XCTAssertEqual(3, localSubject.stack[2] as? Int)
    }

    func test_size_ReturnsCorrectSize() {
        subject.stack = [1, 2, 3]

        let size = subject.size()

        XCTAssertEqual(3, size)
    }

    func test_push_OperatesWithSimilarItems() {
        subject.stack = [1, 2, 3]

        subject.push(4)

        XCTAssertEqual(4, subject.stack.count)
        XCTAssertEqual(4, subject.stack[subject.stack.count - 1] as? Int)
    }

    func test_push_OperatesWithDissimilarItems() {
        subject.stack = [1, "two", 3.0]

        subject.push(true)

        XCTAssertEqual(4, subject.stack.count)
        XCTAssertEqual(true, subject.stack[subject.stack.count - 1] as? Bool)
    }

    func test_push_OperatesWithClosureItems() {
        var testValue = 0
        let three = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.stack = [1, 2.0]

        subject.push(three)

        XCTAssertEqual(3, subject.stack.count)
        let closure = subject.stack[subject.stack.count - 1] as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_push_OperatesWithComplexItems() {
        subject.stack = [1, "two", 3.0]

        subject.push((first: 1, second: 2, third: 3))

        XCTAssertEqual(4, subject.stack.count)
        let topItem = subject.stack[subject.stack.count - 1] as? (first: Int, second: Int, third: Int)
        XCTAssertEqual(1, topItem?.first)
        XCTAssertEqual(2, topItem?.second)
        XCTAssertEqual(3, topItem?.third)
    }

    func test_push_OperatesWithNilItems() {
        subject.stack = [1, "two", 3.0]

        subject.push(nil)

        XCTAssertEqual(4, subject.stack.count)
        let element = subject.stack[subject.stack.count - 1]
        XCTAssertNil(element)
    }

    func test_pop_OperatesWithSimilarItems() {
        subject.stack = [1, 2, 3, 4]

        let popped = subject.pop()

        XCTAssertEqual(3, subject.stack.count)
        XCTAssertTrue(popped.success)
        XCTAssertEqual(4, popped.value as? Int)
    }

    func test_pop_OperatesWithDissimilarItems() {
        subject.stack = [1, "two", 3.0, true]

        let popped = subject.pop()

        XCTAssertEqual(3, subject.stack.count)
        XCTAssertTrue(popped.success)
        XCTAssertEqual(true, popped.value as? Bool)
    }

    func test_pop_OperatesWithClosureItems() {
        var testValue = 0
        let three = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.stack = [1, 2.0, three]

        let popped = subject.pop()

        XCTAssertEqual(2, subject.stack.count)
        XCTAssertTrue(popped.success)
        let closure = popped.value as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_pop_OperatesWithComplexItems() {
        subject.stack = [1, "two", 3.0, (first: 1, second: 2.0)]

        let popped = subject.pop()

        XCTAssertEqual(3, subject.stack.count)
        XCTAssertTrue(popped.success)
        let poppedValue = popped.value as? (first: Int, second: Double)
        XCTAssertEqual(1, poppedValue?.first)
        XCTAssertEqual(2.0, poppedValue?.second)
    }

    func test_pop_OperatesWithNilItems() {
        subject.stack = [1, "two", 3.0, nil]

        let popped = subject.pop()

        XCTAssertEqual(3, subject.stack.count)
        XCTAssertTrue(popped.success)
        XCTAssertNil(popped.value)
    }

    func test_pop_OperatesWithEmptyStack() {
        subject.stack = []

        let popped = subject.pop()

        XCTAssertEqual(0, subject.stack.count)
        XCTAssertFalse(popped.success)
        XCTAssertNil(popped.value)
    }

    func test_clear_ClearsAllEntries() {
        subject.stack = [1, 2, 3]

        subject.clear()

        XCTAssertEqual(0, subject.stack.count)
    }

    func testPushPopCycle() {
        subject.push(1)
        subject.push(2.0)
        subject.push(nil)
        subject.push("three")
        subject.push(false)

        XCTAssertEqual(5, subject.stack.count)
        XCTAssertEqual(1, subject.stack[0] as? Int)
        XCTAssertEqual(2.0, subject.stack[1] as? Double)
        XCTAssertNil(subject.stack[2])
        XCTAssertEqual("three", subject.stack[3] as? String)
        XCTAssertEqual(false, subject.stack[4] as? Bool)

        var popped: (value: Any?, success: Bool)

        popped = subject.pop()
        XCTAssertTrue(popped.success)
        XCTAssertEqual(false, popped.value as? Bool)

        popped = subject.pop()
        XCTAssertTrue(popped.success)
        XCTAssertEqual("three", popped.value as? String)

        popped = subject.pop()
        XCTAssertTrue(popped.success)
        XCTAssertNil(popped.value)

        popped = subject.pop()
        XCTAssertTrue(popped.success)
        XCTAssertEqual(2.0, popped.value as? Double)

        popped = subject.pop()
        XCTAssertTrue(popped.success)
        XCTAssertEqual(1, popped.value as? Int)

        XCTAssertEqual(0, subject.stack.count)

        popped = subject.pop()
        XCTAssertFalse(popped.success)
        XCTAssertNil(popped.value)
    }

}

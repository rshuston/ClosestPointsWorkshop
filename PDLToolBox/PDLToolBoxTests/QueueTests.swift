//
//  QueueTests.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/12/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import XCTest
@testable import PDLToolBox

class QueueTests: XCTestCase {

    var subject: Queue!

    override func setUp() {
        super.setUp()

        subject = Queue()
    }

    override func tearDown() {
        subject = nil

        super.tearDown()
    }

    func test_init_FromList() {
        let localSubject = Queue(fromList: [1, 2, 3])

        XCTAssertEqual(3, localSubject.queue.count)
        XCTAssertEqual(1, localSubject.queue[0] as? Int)
        XCTAssertEqual(2, localSubject.queue[1] as? Int)
        XCTAssertEqual(3, localSubject.queue[2] as? Int)
    }

    func test_size_ReturnsCorrectSize() {
        subject.queue = [1, 2, 3]

        let size = subject.size()

        XCTAssertEqual(3, size)
    }

    func test_enqueue_OperatesWithSimilarItems() {
        subject.queue = [1, 2, 3]

        subject.enqueue(4)

        XCTAssertEqual(4, subject.queue.count)
        XCTAssertEqual(4, subject.queue[subject.queue.count - 1] as? Int)
    }

    func test_enqueue_OperatesWithDissimilarItems() {
        subject.queue = [1, "two", 3.0]

        subject.enqueue(true)

        XCTAssertEqual(4, subject.queue.count)
        XCTAssertEqual(true, subject.queue[subject.queue.count - 1] as? Bool)
    }

    func test_enqueue_OperatesWithClosureItems() {
        var testValue = 0
        let three = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.queue = [1, 2.0]

        subject.enqueue(three)

        XCTAssertEqual(3, subject.queue.count)
        let closure = subject.queue[subject.queue.count - 1] as? ((Int) -> Bool)
        let answer = closure?(3) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 3)
    }

    func test_enqueue_OperatesWithComplexItems() {
        subject.queue = [1, "two", 3.0]

        subject.enqueue((first: 1, second: 2, third: 3))

        XCTAssertEqual(4, subject.queue.count)
        let lastItem = subject.queue[subject.queue.count - 1] as? (first: Int, second: Int, third: Int)
        XCTAssertEqual(1, lastItem?.first)
        XCTAssertEqual(2, lastItem?.second)
        XCTAssertEqual(3, lastItem?.third)
    }

    func test_enqueue_OperatesWithNilItems() {
        subject.queue = [1, "two", 3.0]

        subject.enqueue(nil)

        XCTAssertEqual(4, subject.queue.count)
        let element = subject.queue[subject.queue.count - 1]
        XCTAssertNil(element)
    }

    func test_dequeue_OperatesWithSimilarItems() {
        subject.queue = [1, 2, 3, 4]

        let dequeued = subject.dequeue()

        XCTAssertEqual(3, subject.queue.count)
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual(1, dequeued.value as? Int)
    }

    func test_dequeue_OperatesWithDissimilarItems() {
        subject.queue = [1, "two", 3.0, true]

        let dequeued = subject.dequeue()

        XCTAssertEqual(3, subject.queue.count)
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual(1, dequeued.value as? Int)
    }

    func test_dequeue_OperatesWithClosureItems() {
        var testValue = 0
        let one = {(value: Int) -> Bool in
            testValue = value
            return true
        }
        subject.queue = [one, 2.0, 3]

        let dequeued = subject.dequeue()

        XCTAssertEqual(2, subject.queue.count)
        XCTAssertTrue(dequeued.success)
        let closure = dequeued.value as? ((Int) -> Bool)
        let answer = closure?(1) ?? false
        XCTAssertTrue(answer)
        XCTAssertEqual(testValue, 1)
    }

    func test_dequeue_OperatesWithComplexItems() {
        subject.queue = [(first: 1, second: 2.0), 2, "three", 4.0]

        let dequeued = subject.dequeue()

        XCTAssertEqual(3, subject.queue.count)
        XCTAssertTrue(dequeued.success)
        let dequeuedValue = dequeued.value as? (first: Int, second: Double)
        XCTAssertEqual(1, dequeuedValue?.first)
        XCTAssertEqual(2.0, dequeuedValue?.second)
    }

    func test_dequeue_OperatesWithNilItems() {
        subject.queue = [nil, 2, "three", 4.0]

        let dequeued = subject.dequeue()

        XCTAssertEqual(3, subject.queue.count)
        XCTAssertTrue(dequeued.success)
        XCTAssertNil(dequeued.value)
    }

    func test_dequeue_OperatesWithEmptyStack() {
        subject.queue = []

        let dequeued = subject.dequeue()

        XCTAssertEqual(0, subject.queue.count)
        XCTAssertFalse(dequeued.success)
        XCTAssertNil(dequeued.value)
    }

    func test_clear_ClearsAllEntries() {
        subject.queue = [1, 2, 3]

        subject.clear()

        XCTAssertEqual(0, subject.queue.count)
    }

    func testEnqueueDequeueCycle() {
        subject.enqueue(1)
        subject.enqueue(2.0)
        subject.enqueue(nil)
        subject.enqueue("three")
        subject.enqueue(false)

        XCTAssertEqual(5, subject.queue.count)
        XCTAssertEqual(1, subject.queue[0] as? Int)
        XCTAssertEqual(2.0, subject.queue[1] as? Double)
        XCTAssertNil(subject.queue[2])
        XCTAssertEqual("three", subject.queue[3] as? String)
        XCTAssertEqual(false, subject.queue[4] as? Bool)

        var dequeued: (value: Any?, success: Bool)

        dequeued = subject.dequeue()
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual(1, dequeued.value as? Int)

        dequeued = subject.dequeue()
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual(2.0, dequeued.value as? Double)

        dequeued = subject.dequeue()
        XCTAssertTrue(dequeued.success)
        XCTAssertNil(dequeued.value)

        dequeued = subject.dequeue()
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual("three", dequeued.value as? String)

        dequeued = subject.dequeue()
        XCTAssertTrue(dequeued.success)
        XCTAssertEqual(false, dequeued.value as? Bool)

        XCTAssertEqual(0, subject.queue.count)
        
        dequeued = subject.dequeue()
        XCTAssertFalse(dequeued.success)
        XCTAssertNil(dequeued.value)
    }

}

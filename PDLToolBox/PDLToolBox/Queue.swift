//
//  Queue.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/12/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Foundation

open class Queue {

    // A queue is a FIFO buffer implemented as an array of "Any?" items. Enqueue
    // operations add to the end of the array. Dequeue operations remove from
    // the beginning of the array.

    var queue: [Any?]

    public init() {
        queue = []
    }

    public init(fromList: [Any?]) {
        queue = fromList
    }

    open func size() -> Int {
        return queue.count
    }

    open func enqueue(_ value: Any?) {
        queue.append(value)
    }

    open func dequeue() -> (value: Any?, success: Bool) {
        var value: Any? = nil
        var success = false
        if queue.count > 0 {
            value = queue.removeFirst()
            success = true
        }
        return (value: value, success: success)
    }

    open func clear() {
        queue.removeAll()
    }

}

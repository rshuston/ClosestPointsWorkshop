//
//  Stack.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/5/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Foundation

open class Stack {

    // A stack is a LIFO buffer implemented as an array of "Any?" items. Push
    // operations add to the end of the array. Pop operations remove from the
    // end of the array.

    var stack: [Any?]

    public init() {
        stack = []
    }

    public init(fromList: [Any?]) {
        stack = fromList
    }

    open func size() -> Int {
        return stack.count
    }

    open func push(_ value: Any?) {
        stack.append(value)
    }

    open func pop() -> (value: Any?, success: Bool) {
        var value: Any? = nil
        var success = false
        if stack.count > 0 {
            value = stack.removeLast()
            success = true
        }
        return (value: value, success: success)
    }

    open func clear() {
        stack.removeAll()
    }
    
}

//
//  SegmentedSequenceList.swift
//  PDLToolBox
//
//  Created by Robert Huston on 6/5/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Foundation

open class SegmentedSequenceList {

    // A segmented sequence list is an array of sequence segments which span
    // an ordered index series. The idea is that each segment applies a value
    // for the given index range. A value can be any swift entity, and each
    // segment can have a different value type.
    //
    // One application of the segmented sequence list is to mock out the return
    // values for a given sequence of calls to a function. For example, the
    // first 5 calls can be one value, the next 3 calls can be another value,
    // and so on. Queries beyond the lowest or the highest segments evaluate
    // to that segment's value.
    //
    // Example sequence:
    //
    //                  value3
    //    value1  value2  |  value4
    // ... ----  -------  -  - ...
    //     |  |  |  |  |  |  |
    // ... 1  2  3  4  5  6  7 ...
    //
    // -∞ , value1
    //  1 , value1
    //  2 , value1
    //  3 , value2
    //  4 , value2
    //  5 , value2
    //  6 , value3
    //  7 , value4
    //  ∞ , value4
    //
    // Example sequence list structure:
    // 0: [1, value1]  1...2 = value1
    // 1: [3, value2]  3...5 = value2
    // 2: [6, value3]  6...6 = value3
    // 3: [7, value4]  7...∞ = value4

    var sequenceList: [(index: Int, value: Any?)]

    public init() {
        sequenceList = []
    }

    public init(fromList: [(index: Int, value: Any?)]) {
        sequenceList = fromList
    }

    open func clear() {
        sequenceList.removeAll()
    }

    open func setValue(_ value: Any?, forIndex index: Int) {
        var alreadyExists = false
        for i in 0..<sequenceList.count {
            if sequenceList[i].index == index {
                alreadyExists = true
                sequenceList[i].value = value
                break;
            }
        }
        if !alreadyExists {
            sequenceList.append((index, value))
            sequenceList.sort(by: { (entry1: (index: Int, value: Any?), entry2: (index: Int, value: Any?)) -> Bool in
                return entry1.index <= entry2.index
            })
        }
    }

    open func getValueFor(_ index: Int) -> (value: Any?, success: Bool) {
        var result: (value: Any?, success: Bool) = (nil, false)
        if sequenceList.count > 0 {
            if sequenceList.count == 1 {
                // If only one entry, it doesn't matter what index we're requesting
                let entry = sequenceList[0]
                result.value = entry.value
                result.success = true
            } else if index <= sequenceList.first!.index {
                let entry = sequenceList.first!
                result.value = entry.value
                result.success = true
            } else if index >= sequenceList.last!.index {
                let entry = sequenceList.last!
                result.value = entry.value
                result.success = true
            } else {
                var bestEntrySoFar: (index: Int, value: Any?)! = nil
                for entry in sequenceList {
                    if index >= entry.index {
                        bestEntrySoFar = entry
                    }
                }
                if bestEntrySoFar != nil {
                    result.value = bestEntrySoFar.value
                    result.success = true
                }
            }
        }
        return result
    }
}

//
//  FuncRecorder.swift
//  PDLTestBench
//
//  Created by Robert Huston on 6/4/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Foundation

open class FuncRecorder {

    // Dictionary of call names, containing arrays of parameter lists
    // for each invocation of a call name
    var callHistoryDictionary: [ String : [ [Any?] ] ]

    public init() {
        callHistoryDictionary = [:]
    }

    open func recordCallFor(_ name: String, params: [Any?]) {
        if callHistoryDictionary.keys.contains(name) {
            callHistoryDictionary[name]!.append(params)
        } else {
            callHistoryDictionary[name] = [params]
        }
    }

    open func getCallCountFor(_ name: String) -> Int {
        return callHistoryDictionary[name]?.count ?? 0
    }

    open func getCallHistoryFor(_ name: String) -> [[Any?]]? {
        return callHistoryDictionary[name]
    }

    open func getCallRecordFor(_ name: String, forInvocation invocation: Int = 0) -> [Any?]? {
        guard let callHistory = callHistoryDictionary[name]
            , invocation < callHistory.count
            else {
                return nil
        }
        return callHistory[invocation]
    }

    open func clearCallHistoryFor(_ name: String) {
        if callHistoryDictionary.keys.contains(name) {
            callHistoryDictionary.removeValue(forKey: name)
        }
    }

    open func clearAllCallHistories() {
        callHistoryDictionary.removeAll()
    }

}

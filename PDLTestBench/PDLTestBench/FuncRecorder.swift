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

    // Dictionary of call names, containing arrays of return values
    // for each invocation of a call name
    var returnHistoryDictionary: [ String : [Any?] ]

    public init() {
        callHistoryDictionary = [:]
        returnHistoryDictionary = [:]
    }

    // MARK: - Call history

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
        guard let callHistory = callHistoryDictionary[name], invocation < callHistory.count else {
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

    // MARK: - Return history

    open func recordReturnFor(_ name: String, value: Any?) {
        if returnHistoryDictionary.keys.contains(name) {
            returnHistoryDictionary[name]!.append(value)
        } else {
            returnHistoryDictionary[name] = [value]
        }
    }

    open func getReturnCountFor(_ name: String) -> Int {
        return returnHistoryDictionary[name]?.count ?? 0
    }

    open func getReturnHistoryFor(_ name: String) -> [Any?]? {
        return returnHistoryDictionary[name]
    }

    open func getReturnValueFor(_ name: String, forInvocation invocation: Int = 0) -> Any? {
        guard let returnHistory = returnHistoryDictionary[name], invocation < returnHistory.count else {
            return nil
        }
        return returnHistory[invocation]
    }

    open func clearReturnHistoryFor(_ name: String) {
        if returnHistoryDictionary.keys.contains(name) {
            returnHistoryDictionary.removeValue(forKey: name)
        }
    }

    open func clearAllReturnHistories() {
        returnHistoryDictionary.removeAll()
    }

}

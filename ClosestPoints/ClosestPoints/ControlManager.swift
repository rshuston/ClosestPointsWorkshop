//
//  ControlManager.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/3/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class ControlManager: NSObject {

    enum SolutionType {
        case NaiveCombination
        case SortedSearch
        case PlaneSweep
        case DivideAndConquer
    }

    enum SolverOption {
        case Live
        case FastAnimation
        case SlowAnimation
        case SingleStep
    }

    var solutionType = SolutionType.NaiveCombination
    var solverOption = SolverOption.Live
    
}

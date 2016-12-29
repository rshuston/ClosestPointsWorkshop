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
        case PermutationSearch
        case CombinationSearch
        case PlaneSweep
        case DivideAndConquer_3
        case DivideAndConquer_5
        case DivideAndConquer_7
    }

    enum SolverOption {
        case OneShot
        case SlowAnimation
        case FastAnimation
        case Live
    }

    var solutionType = SolutionType.PermutationSearch
    var solverOption = SolverOption.Live
    
}

//
//  SolutionEngine.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/3/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class SolutionEngine: NSObject {

    var solving = false

    var permutationSolver: PermutationSolver! = PermutationSolver()
    var combinationSolver: CombinationSolver! = CombinationSolver()
    var planeSweepSolver: PlaneSweepSolver! = PlaneSweepSolver()
    var divideAndConquerSolver: DivideAndConquerSolver! = DivideAndConquerSolver()

}

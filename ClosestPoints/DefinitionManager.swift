//
//  DefinitionManager.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/3/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class DefinitionManager: NSObject {

    enum PointDistribution {
        case Uniform
        case Clustered
    }

    var numberOfPoints = 0
    var distribution = PointDistribution.Uniform

}

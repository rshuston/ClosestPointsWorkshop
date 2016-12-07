//
//  Solver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Solver: NSObject {

    func findClosestPoints(points: [Point],
                           monitor: (((Point, Point)?) -> Void)?,
                           completion: (((Point, Point)?) -> Void)) {
        completion(nil)
    }

}

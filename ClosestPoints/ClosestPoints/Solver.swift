//
//  Solver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Solver: NSObject {

    // points:
    // the point array to search
    //
    // monitor:
    // optional closure that passes the current point pair, and the best point pair so far (optional)
    //
    // completion:
    // closure that passes the found closest point pair (optional)
    //
    // (Eewww! A comment! How untrendy! The horror of it all! Whaah! What can it mean?)

    func findClosestPoints(points: [Point],
                           monitor: (((Point, Point), (Point, Point)?) -> Bool)?,
                           completion: (((Point, Point)?) -> Void)) {
    }

}

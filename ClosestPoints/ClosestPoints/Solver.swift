//
//  Solver.swift
//  ClosestPoints
//
//  Created by Robert Huston on 12/7/16.
//  Copyright © 2016 Pinpoint Dynamics. All rights reserved.
//

import Cocoa

class Solver: NSObject {

    // Solve is an abstract class that defines the interface to be used for all of the
    // solution types. It was better to use inheritance instead of protocol adoption
    // (e.g., we get a little better control in mocking for our tests).
    //
    // points:
    // the point array to search
    //
    // monitor:
    // optional closure that passes the checked rectangle (optional), the current point
    // pair (optional), and the best point pair so far (optional)
    //
    // completion:
    // closure that passes the found closest point pair (optional)
    //
    // (Eewww! A comment! How untrendy! The horror of it all! Whaah! What can it mean?)

    func findClosestPoints(points: [Point],
                           monitor: ((NSRect?, (Point, Point)?, (Point, Point)?) -> Bool)?,
                           completion: (((Point, Point)?) -> Void)?) {
    }

}
